from django.conf import settings
from django.db import models
from django.utils import timezone
import uuid

# Helper function for generating short case IDs (if you want to keep them short)
def generate_case_id():
    return str(uuid.uuid4())[:8]

# ---------------------------
# Order Model
# ---------------------------
class Order(models.Model):
    amazon_order_id = models.CharField(max_length=64, unique=True, db_index=True)
    sku = models.CharField(max_length=128, blank=True)
    title = models.CharField(max_length=255)
    customer_name = models.CharField(max_length=255, blank=True)
    customer_email = models.EmailField(blank=True)
    order_date = models.DateTimeField(default=timezone.now)
    amount = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-order_date']

    def __str__(self):
        return f"{self.amazon_order_id} — {self.title}"


# ---------------------------
# Return Model
# ---------------------------
class Return(models.Model):
    order = models.ForeignKey(Order, related_name='returns', on_delete=models.CASCADE)
    return_reason = models.CharField(max_length=255)
    tracking_number = models.CharField(max_length=128, blank=True)
    return_date = models.DateTimeField(default=timezone.now)
    condition_on_return = models.TextField(blank=True)
    notes = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-return_date']

    def __str__(self):
        return f"Return for Order {self.order.amazon_order_id}"


# ---------------------------
# Dispute Case Model
# ---------------------------
class DisputeCase(models.Model):
    case_id = models.CharField(
        max_length=64,
        unique=True,
        default=generate_case_id,
        editable=False,
        db_index=True,
        verbose_name="Case ID",
        help_text="Unique identifier for the dispute case"
    )
    title = models.CharField(max_length=255)
    description = models.TextField()
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='dispute_cases'
    )
    linked_order = models.ForeignKey(Order, null=True, blank=True, on_delete=models.SET_NULL, related_name='dispute_cases')
    linked_returns = models.ManyToManyField(Return, related_name='dispute_cases', blank=True)
    resolution_notes = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Case {self.case_id} — {self.title}"

    @property
    def short_id(self):
        """Returns a short version of the case ID (first 8 chars)."""
        return str(self.case_id)[:8]


# ---------------------------
# Optional: Evidence for Disputes
# ---------------------------
class DisputeEvidence(models.Model):
    dispute_case = models.ForeignKey(DisputeCase, on_delete=models.CASCADE, related_name='evidences')
    file = models.FileField(upload_to='dispute_evidence/')
    description = models.TextField(blank=True)
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Evidence for Case {self.dispute_case.case_id}"
