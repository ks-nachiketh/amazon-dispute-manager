// Returns Dashboard JavaScript
document.addEventListener('DOMContentLoaded', function() {
    initializeReturnsDashboard();
});

function showModal(){
    var modalEl = document.getElementById('modal');
    var modal = new bootstrap.Modal(modalEl);
    modal.show();
}

function initializeReturnsDashboard() {
    // HTMX afterSwap event listener for table updates
    document.body.addEventListener('htmx:afterSwap', (event) => {
        if (event.detail && event.detail.target && event.detail.target.id === "returns-table-body") {
            var modalEl = document.getElementById('modal');
            var bsModal = bootstrap.Modal.getInstance(modalEl);
            if (bsModal) bsModal.hide();
        }
    });

    // Add Return button event listener
    const addReturnBtn = document.getElementById('create-return-btn');
    if (addReturnBtn) {
        addReturnBtn.addEventListener('click', () => {
            if (typeof htmx === 'undefined') {
                fetch(addReturnBtn.getAttribute('hx-get'))
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

// Toggle select all checkboxes functionality
function toggleSelectAll(selectAllCheckbox) {
    const checkboxes = document.querySelectorAll('input[name="selected_returns"]');
    checkboxes.forEach(checkbox => {
        checkbox.checked = selectAllCheckbox.checked;
    });
}

// Delete selected returns functionality
function deleteSelectedReturns() {
    const selectedCheckboxes = document.querySelectorAll('input[name="selected_returns"]:checked');
    
    if (selectedCheckboxes.length === 0) {
        alert('Please select at least one return to delete.');
        return;
    }

    if (confirm(`Are you sure you want to delete ${selectedCheckboxes.length} selected return(s)?`)) {
        const selectedIds = Array.from(selectedCheckboxes).map(checkbox => parseInt(checkbox.value));
        
        // Get CSRF token
        const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]')?.value || 
                         document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') ||
                         getCookie('csrftoken');

        // Send DELETE request with JSON data
        fetch(window.returnDeleteUrl, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'X-CSRFToken': csrfToken,
            },
            body: JSON.stringify({
                ids: selectedIds
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Remove deleted rows from the table
                selectedCheckboxes.forEach(checkbox => {
                    const row = checkbox.closest('tr');
                    if (row) {
                        row.remove();
                    }
                });
                
                // Uncheck the select all checkbox
                const selectAllCheckbox = document.getElementById('select-all');
                if (selectAllCheckbox) {
                    selectAllCheckbox.checked = false;
                }
                
                // Show success message
                showNotification(`Successfully deleted ${data.deleted_count} return(s).`, 'success');
            } else {
                showNotification(data.error || 'Error deleting returns. Please try again.', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('Error deleting returns. Please try again.', 'error');
        });
    }
}

// Helper function to get CSRF token from cookies
function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

// Show notification function
function showNotification(message, type) {
    // Create a simple notification element
    const notification = document.createElement('div');
    notification.className = `alert alert-${type === 'success' ? 'success' : 'danger'} alert-dismissible fade show`;
    notification.style.position = 'fixed';
    notification.style.top = '20px';
    notification.style.right = '20px';
    notification.style.zIndex = '9999';
    notification.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(notification);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.parentNode.removeChild(notification);
        }
    }, 5000);
}