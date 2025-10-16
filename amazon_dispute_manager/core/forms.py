from django import forms
from .models import DisputeCase, Order, Return

class DisputeCaseForm(forms.ModelForm):
    class Meta:
        model = DisputeCase
        fields = ["title", "description", "linked_order", "linked_returns", "resolution_notes"]
        widgets = {
            "linked_returns": forms.CheckboxSelectMultiple(),
            "description": forms.Textarea(attrs={'rows': 4}),
            "resolution_notes": forms.Textarea(attrs={'rows': 3}),
        }

class OrderForm(forms.ModelForm):
    class Meta:
        model = Order
        fields = ["amazon_order_id", "sku", "title", "customer_name", "customer_email", "order_date", "amount"]
        labels = {
            'sku': 'SKU (Stock Keeping Unit)',
        }
        help_texts = {
            'sku': 'Unique identifier used by sellers to track product inventory and variants',
        }
        widgets = {
            "order_date": forms.DateTimeInput(attrs={"type": "datetime-local"}),
            'sku': forms.TextInput(attrs={
                'title': 'Stock Keeping Unit - Unique identifier used by sellers to track product inventory and variants',
                'placeholder': 'Enter product SKU',
            }),
        }

class ReturnForm(forms.ModelForm):
    class Meta:
        model = Return
        fields = ["order", "return_reason", "tracking_number", "return_date", "condition_on_return", "notes"]
        widgets = {
            "return_date": forms.DateTimeInput(attrs={"type": "datetime-local"}),
            "condition_on_return": forms.Textarea(attrs={"rows": 3}),
            "notes": forms.Textarea(attrs={"rows": 3}),
        }

