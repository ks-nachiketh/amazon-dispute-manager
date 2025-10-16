from django.shortcuts import render, redirect
from django.views.generic import ListView
from django.http import HttpResponse, JsonResponse
from django.template.loader import render_to_string
from .models import DisputeCase, Order, Return
from .forms import DisputeCaseForm, OrderForm, ReturnForm
import logging
from django.db.models import Count
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
import json


logger = logging.getLogger(__name__)

class DisputeListView(ListView):
    model = DisputeCase
    template_name = "dashboards/disputes/dispute_list.html"
    context_object_name = "disputes"
    paginate_by = 50

def dispute_create_modal(request):
    form = DisputeCaseForm()
    return render(request, "dashboards/disputes/partials/dispute_modal_form.html", {"form": form})

def dispute_create(request):
    # This view expects hx-post (HTMX). It returns a redirect on success
    logger = logging.getLogger(__name__)
    # Log the incoming method and a few useful headers to help debug 405/METHOD NOT ALLOWED
    try:
        hdrs = {
            'HX-Request': request.headers.get('HX-Request'),
            'Content-Type': request.headers.get('Content-Type'),
            'X-CSRFToken': request.headers.get('X-CSRFToken'),
        }
    except Exception:
        hdrs = {}
    logger.debug("dispute_create called: method=%s, headers=%s", request.method, hdrs)

    # Support GET here so a browser visit to /disputes/create/ doesn't return 405.
    # Prefer to show the same modal form (route exists at 'disputes/new/')
    if request.method == "GET":
        return redirect('core:dispute_create_modal')

    if request.method == "POST":
        form = DisputeCaseForm(request.POST)
        if form.is_valid():
            dispute = form.save(commit=False)
            if request.user.is_authenticated:
                dispute.created_by = request.user
            dispute.save()
            form.save_m2m()
            
            # Check if it's an HTMX request
            if request.headers.get('HX-Request'):
                # For HTMX requests, return a response that triggers a redirect
                response = HttpResponse()
                response['HX-Redirect'] = '/disputes/'
                return response
            else:
                # For regular form submissions, redirect normally
                return redirect('core:dispute_list')
        else:
            # Return the form with errors back into the modal body
            return render(request, "dashboards/disputes/partials/dispute_modal_form.html", {"form": form}, status=400)
    logger.info("dispute_create: Method not allowed (%s)", request.method)
    return HttpResponse('Method Not Allowed', status=405)

class OrderListView(ListView):
    model = Order
    template_name = "dashboards/orders/order_list.html"
    context_object_name = "orders"
    paginate_by = 50

def order_create_modal(request):
    form = OrderForm()
    return render(request, "dashboards/orders/partials/order_modal_form.html", {"form": form})

def order_create(request):
    if request.method == "GET":
        return redirect("core:order_create_modal")

    if request.method == "POST":
        form = OrderForm(request.POST)
        if form.is_valid():
            order = form.save()
            
            # Check if it's an HTMX request
            if request.headers.get('HX-Request'):
                # For HTMX requests, return a response that triggers a redirect
                response = HttpResponse()
                response['HX-Redirect'] = '/orders/'
                return response
            else:
                # For regular form submissions, redirect normally
                return redirect('core:order_list')
        return render(request, "dashboards/orders/partials/order_modal_form.html", {"form": form})

class ReturnListView(ListView):
    model = Return
    template_name = "dashboards/returns/return_list.html"
    context_object_name = "returns"
    paginate_by = 50

def return_create_modal(request):
    form = ReturnForm()
    return render(request, "dashboards/returns/partials/return_modal_form.html", {"form": form})

def return_create(request):
    if request.method == "GET":
        return redirect("core:return_create_modal")

    if request.method == "POST":
        form = ReturnForm(request.POST)
        if form.is_valid():
            return_instance = form.save()
            
            # Check if it's an HTMX request
            if request.headers.get('HX-Request'):
                # For HTMX requests, return a response that triggers a redirect
                response = HttpResponse()
                response['HX-Redirect'] = '/returns/'
                return response
            else:
                # For regular form submissions, redirect normally
                return redirect('core:return_list')
        return render(request, "dashboards/returns/partials/return_modal_form.html", {"form": form})

def homepage(request):
    return render(request, "dashboards/homepage/homepage.html")

def analytics_dashboard(request):
    open_disputes = DisputeCase.objects.count()
    open_orders = Order.objects.filter().count()
    open_returns = Return.objects.filter().count()

    category_analytics = {
        "disputes": DisputeCase.objects.values("title").annotate(count=Count("title")),
        "orders": Order.objects.values("title").annotate(count=Count("title")),
        "returns": Return.objects.values("return_reason").annotate(count=Count("return_reason")),
    }

    context = {
        "open_disputes": open_disputes,
        "open_orders": open_orders,
        "open_returns": open_returns,
        "category_analytics": category_analytics,
    }

    return render(request, "dashboards/analytics/analytics_dashboard.html", context)

@csrf_exempt
@require_http_methods(["DELETE"])
def dispute_delete(request):
    try:
        body = json.loads(request.body)
        dispute_ids = body.get("ids", [])
        if not dispute_ids:
            return JsonResponse({"error": "No dispute IDs provided."}, status=400)

        deleted_count, _ = DisputeCase.objects.filter(id__in=dispute_ids).delete()
        return JsonResponse({"success": True, "deleted_count": deleted_count})
    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON."}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

@csrf_exempt
@require_http_methods(["DELETE"])
def order_delete(request):
    try:
        body = json.loads(request.body)
        order_ids = body.get("ids", [])
        if not order_ids:
            return JsonResponse({"error": "No order IDs provided."}, status=400)

        deleted_count, _ = Order.objects.filter(id__in=order_ids).delete()
        return JsonResponse({"success": True, "deleted_count": deleted_count})
    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON."}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

@csrf_exempt
@require_http_methods(["DELETE"])
def return_delete(request):
    try:
        body = json.loads(request.body)
        return_ids = body.get("ids", [])
        if not return_ids:
            return JsonResponse({"error": "No return IDs provided."}, status=400)

        deleted_count, _ = Return.objects.filter(id__in=return_ids).delete()
        return JsonResponse({"success": True, "deleted_count": deleted_count})
    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON."}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
