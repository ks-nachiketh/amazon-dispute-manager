from django.urls import path
from . import views

app_name = "core"

urlpatterns = [
    
    # Homepage
    path('', views.homepage, name='homepage'),

    # Disputes
    path('disputes/', views.DisputeListView.as_view(), name='dispute_list'),
    path('disputes/new/', views.dispute_create_modal, name='dispute_create_modal'),
    path('disputes/create/', views.dispute_create, name='dispute_create'),
    path('disputes/delete/', views.dispute_delete, name='dispute_delete'),  # URL pattern for dispute deletion

    # Orders
    path('orders/', views.OrderListView.as_view(), name='order_list'),
    path('orders/new/', views.order_create_modal, name='order_create_modal'),
    path('orders/create/', views.order_create, name='order_create'),
    path('orders/delete/', views.order_delete, name='order_delete'),  # URL pattern for order deletion

    # Returns
    path('returns/', views.ReturnListView.as_view(), name='return_list'),
    path('returns/new/', views.return_create_modal, name='return_create_modal'),
    path('returns/create/', views.return_create, name='return_create'),
    path('returns/delete/', views.return_delete, name='return_delete'),  # URL pattern for return deletion

    # Analytics
    path('analytics/', views.analytics_dashboard, name='analytics_dashboard'),

]
