// Disputes Dashboard JavaScript
document.addEventListener('DOMContentLoaded', function() {
    initializeDisputesDashboard();
});

function showModal(){
    var modalEl = document.getElementById('modal');
    var modal = new bootstrap.Modal(modalEl);
    modal.show();
}

function initializeDisputesDashboard() {
    // HTMX afterSwap event listener for table updates
    document.body.addEventListener('htmx:afterSwap', (event) => {
        // Close modal when a partial with a table row is swapped into the DOM
        if (event.detail.target.id === "disputes-table-body") {
            var modalEl = document.getElementById('modal');
            var bsModal = bootstrap.Modal.getInstance(modalEl);
            if (bsModal) bsModal.hide();
        }
    });

    // Create dispute button event listener with fallback
    const createDisputeBtn = document.getElementById('create-dispute-btn');
    if (createDisputeBtn) {
        createDisputeBtn.addEventListener('click', function(e){
            // Debug information in the console
            console.log('Create Dispute clicked. htmx:', typeof htmx, 'bootstrap:', typeof bootstrap);

            // If HTMX is not present, manually fetch the form and show the modal as a fallback
            if (typeof htmx === 'undefined') {
                e.preventDefault();
                var url = createDisputeBtn.getAttribute('hx-get');
                console.log('HTMX not found — fetching form via fetch():', url);
                fetch(url, {credentials: 'same-origin'})
                    .then(function(resp){ 
                        if (!resp.ok) throw new Error('Network response not ok: '+resp.status); 
                        return resp.text(); 
                    })
                    .then(function(html){
                        document.getElementById('modal-body').innerHTML = html;
                        try { 
                            showModal(); 
                        } catch (err) { 
                            console.error('showModal failed', err); 
                        }
                    })
                    .catch(function(err){ 
                        console.error('Failed to load modal form fallback:', err); 
                    });
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

function deleteSelectedDisputes() {
    const selected = Array.from(document.querySelectorAll('input[name="selected_disputes"]:checked'))
        .map(cb => cb.value);

    if (selected.length === 0) {
        alert('No disputes selected.');
        return;
    }

    // Get CSRF token from the page
    const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]')?.value || 
                     document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

    fetch(window.disputeDeleteUrl, {
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
            alert('Failed to delete disputes.');
        }
    })
    .catch(error => {
        console.error('Error deleting disputes:', error);
        alert('Failed to delete disputes.');
    });
}

function toggleSelectAll(checkbox) {
    const checkboxes = document.querySelectorAll('input[name="selected_disputes"]');
    checkboxes.forEach(cb => cb.checked = checkbox.checked);
}