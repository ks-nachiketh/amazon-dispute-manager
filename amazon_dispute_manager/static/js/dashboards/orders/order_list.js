// Orders Dashboard JavaScript
document.addEventListener('DOMContentLoaded', function() {
    initializeOrdersDashboard();
});

function showModal(){
    var modalEl = document.getElementById('modal');
    var modal = new bootstrap.Modal(modalEl);
    modal.show();
}

function initializeOrdersDashboard() {
    // HTMX afterSwap event listener for table updates
    document.body.addEventListener('htmx:afterSwap', (event) => {
        if (event.detail && event.detail.target && event.detail.target.id === "orders-table-body") {
            var modalEl = document.getElementById('modal');
            var bsModal = bootstrap.Modal.getInstance(modalEl);
            if (bsModal) bsModal.hide();
        }
    });

    // Add Order button event listener
    const addOrderBtn = document.getElementById('create-order-btn');
    if (addOrderBtn) {
        addOrderBtn.addEventListener('click', () => {
            if (typeof htmx === 'undefined') {
                fetch(addOrderBtn.getAttribute('hx-get'))
                    .then(response => response.text())
                    .then(html => {
                        document.getElementById('modal-body').innerHTML = html;
                        showModal();
                    })
                    .catch(error => console.error('Error loading modal form:', error));
            }
        });
    }

    // Modal hidden event listener
    const modalEl = document.getElementById('modal');
    if (modalEl) {
        modalEl.addEventListener('hidden.bs.modal', function () {
            document.querySelector('.modal-backdrop')?.remove();
        });
    }
}

function deleteSelectedOrders() {
    const selected = Array.from(document.querySelectorAll('input[name="selected_orders"]:checked'))
        .map(cb => cb.value);

    if (selected.length === 0) {
        alert('No orders selected.');
        return;
    }

    // Get CSRF token from the page
    const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]')?.value || 
                     document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

    fetch(window.orderDeleteUrl, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': csrfToken
        },
        body: JSON.stringify({ ids: selected })
    })
    .then(response => {
        if (response.ok) {
            location.reload();
        } else {
            alert('Failed to delete orders.');
        }
    })
    .catch(error => {
        console.error('Error deleting orders:', error);
        alert('Failed to delete orders.');
    });
}

function toggleSelectAll(checkbox) {
    const checkboxes = document.querySelectorAll('input[name="selected_orders"]');
    checkboxes.forEach(cb => cb.checked = checkbox.checked);
}