from django.core.management.base import BaseCommand
from core.models import Order, DisputeCase, Return
from django.utils.timezone import now

class Command(BaseCommand):
    help = 'Populate the database with dummy data for orders, disputes, and returns.'

    def handle(self, *args, **kwargs):
        # Create dummy orders
        if not Order.objects.filter(amazon_order_id='DUMMYORDER001').exists():
            order1 = Order.objects.create(
                amazon_order_id='DUMMYORDER001',
                sku='SKU001',
                title='Dummy Product 1',
                customer_name='John Doe',
                customer_email='john.doe@example.com',
                order_date=now(),
                amount=100.50
            )

        if not Order.objects.filter(amazon_order_id='DUMMYORDER002').exists():
            order2 = Order.objects.create(
                amazon_order_id='DUMMYORDER002',
                sku='SKU002',
                title='Dummy Product 2',
                customer_name='Jane Smith',
                customer_email='jane.smith@example.com',
                order_date=now(),
                amount=200.75
            )

        # Create dummy disputes
        if not DisputeCase.objects.filter(title='Dispute for Order 1').exists():
            dispute1 = DisputeCase.objects.create(
                title='Dispute for Order 1',
                description='This is a dummy dispute for testing.',
                linked_order=order1,
                status=DisputeCase.STATUS_OPEN
            )

        if not DisputeCase.objects.filter(title='Dispute for Order 2').exists():
            dispute2 = DisputeCase.objects.create(
                title='Dispute for Order 2',
                description='Another dummy dispute for testing.',
                linked_order=order2,
                status=DisputeCase.STATUS_IN_REVIEW
            )

        # Create dummy returns
        if not Return.objects.filter(amazon_return_id='DUMMYRETURN001').exists():
            return1 = Return.objects.create(
                amazon_return_id='DUMMYRETURN001',
                order=order1,
                return_reason='Damaged item',
                tracking_number='TRACK001',
                return_date=now(),
                condition_on_return='Damaged',
                notes='Item was damaged on arrival.'
            )

        if not Return.objects.filter(amazon_return_id='DUMMYRETURN002').exists():
            return2 = Return.objects.create(
                amazon_return_id='DUMMYRETURN002',
                order=order2,
                return_reason='Wrong item sent',
                tracking_number='TRACK002',
                return_date=now(),
                condition_on_return='Good',
                notes='Wrong item was sent to the customer.'
            )

        self.stdout.write(self.style.SUCCESS('Dummy data populated successfully!'))