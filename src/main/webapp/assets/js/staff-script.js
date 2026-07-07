// Danh sách món trong giỏ hàng
let cart = [];
// Danh mục món đang chọn
let currentCategory = 'all';
// Ô tìm kiếm món
let searchKeyword = '';
// Tiền giảm giá
let appliedDiscount = 0;

// Chống mã độc, đổi các ký tự đặc biệt để bảo mật
function escapeHtml(value) {
    return String(value ?? '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}

// Lưu giỏ hàng vào bộ nhớ trình duyệt để tải lại trang không bị mất
function saveCart() {
    localStorage.setItem('sun_coffee_cart', JSON.stringify(cart));
}

// Lấy dữ liệu giỏ hàng đã lưu trước đó ra
function loadCart() {
    try {
        const data = localStorage.getItem('sun_coffee_cart');
        cart = data ? JSON.parse(data) : [];
    } catch (e) {
        cart = [];
    }
}

// Thêm một sản phẩm mới vào giỏ hàng
function addToCart(productId, name, price) {
    productId = Number(productId);
    price = Number(price) || 0;
    
    // Tìm xem món đã có trong giỏ chưa
    const existingItem = cart.find(item => item.productId === productId);
    if (existingItem) {
        // Nếu có rồi thì tăng số lượng
        existingItem.qty += 1;
    } else {
        // Chưa có thì thêm mới
        cart.push({ productId, name, price, qty: 1 });
    }
    
    saveCart();   // Lưu lại
    renderCart(); // Cập nhật giao diện
    showToast('Đã thêm: ' + name, 'toast-added');
}

// Thay đổi số lượng của sản phẩm trong giỏ hàng
function updateQty(productId, delta) {
    productId = Number(productId);
    const item = cart.find(i => i.productId === productId);
    if (!item) return;
    
    item.qty += delta;
    if (item.qty <= 0) {
        // Số lượng bằng 0 thì xóa khỏi giỏ
        removeFromCart(productId);
    } else {
        saveCart();
        renderCart();
    }
}

// Xóa sản phẩm ra khỏi giỏ hàng
function removeFromCart(productId) {
    productId = Number(productId);
    cart = cart.filter(item => item.productId !== productId);
    saveCart();
    renderCart();
    showToast('Đã xóa món khỏi đơn hàng', 'toast-error');
}

// Hủy toàn bộ đơn hàng
function clearCart() {
    if (cart.length === 0) return;
    if (!confirm('Bạn có chắc chắn muốn xóa toàn bộ đơn hàng?')) return;
    
    cart = [];
    saveCart();
    appliedDiscount = 0;
    
    const discountInput = document.getElementById('discount-amount');
    const noteInput = document.getElementById('order-note');
    if (discountInput) discountInput.value = '';
    if (noteInput) noteInput.value = '';
    
    renderCart();
    showToast('Đã xóa toàn bộ đơn hàng', 'toast-error');
}

// Tính tiền chưa giảm giá
function getSubtotal() {
    return cart.reduce((sum, item) => sum + item.price * item.qty, 0);
}

// Lấy tiền giảm giá
function getDiscount() {
    return appliedDiscount;
}

// Tính tổng tiền phải trả
function getTotal() {
    return Math.max(0, getSubtotal() - getDiscount());
}

// Định dạng tiền Việt Nam Đồng
function formatVND(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
        maximumFractionDigits: 0
    }).format(Number(amount) || 0);
}

// Thêm dấu chấm phần nghìn
function formatNumberWithDots(val) {
    const num = Math.floor(Number(val) || 0);
    return num.toLocaleString('vi-VN');
}

// Bỏ dấu chấm phần nghìn
function parseNumberFromDots(val) {
    return Math.floor(Number(String(val || '').replace(/\./g, '')) || 0);
}

// Áp dụng giảm giá khi nhấn nút hoặc click ra ngoài ô nhập
function applyDiscount() {
    const input = document.getElementById('discount-amount');
    if (!input) return;
    let raw = parseNumberFromDots(input.value);
    appliedDiscount = Math.max(0, raw);
    input.value = appliedDiscount > 0 ? formatNumberWithDots(appliedDiscount) : '';
    renderCart();
}

// Hiển thị giỏ hàng lên màn hình
function renderCart() {
    const cartContainer = document.getElementById('cart-items');
    const emptyMsg = document.getElementById('cart-empty');
    const payBtn = document.getElementById('pay-btn');
    const subtotalEl = document.getElementById('subtotal');
    const totalEl = document.getElementById('grand-total');
    const itemCountEl = document.getElementById('cart-item-count');

    if (!cartContainer) return;

    if (cart.length === 0) {
        cartContainer.innerHTML = '';
        cartContainer.style.setProperty('display', 'none', 'important');
        if (emptyMsg) {
            emptyMsg.style.setProperty('display', 'flex', 'important');
        }
        if (payBtn) payBtn.disabled = true;
    } else {
        if (emptyMsg) {
            emptyMsg.style.setProperty('display', 'none', 'important');
        }
        cartContainer.style.setProperty('display', 'block', 'important');
        if (payBtn) payBtn.disabled = false;

        cartContainer.innerHTML = cart.map(item => `
            <div class="cart-item" data-product-id="${item.productId}">
                <div class="cart-item-info">
                    <div class="cart-item-name">${escapeHtml(item.name)}</div>
                    <div class="cart-item-price">
                        ${formatVND(item.price)} &times; ${item.qty}
                        = <strong>${formatVND(item.price * item.qty)}</strong>
                    </div>
                </div>
                <div class="qty-controls">
                    <button type="button" class="qty-btn" onclick="updateQty(${item.productId}, -1)" title="Giảm số lượng">&minus;</button>
                    <span class="qty-number">${item.qty}</span>
                    <button type="button" class="qty-btn" onclick="updateQty(${item.productId}, 1)" title="Tăng số lượng">+</button>
                    <button type="button" class="qty-btn remove" onclick="removeFromCart(${item.productId})" title="Xóa khỏi đơn">&times;</button>
                </div>
            </div>
        `).join('');
    }

    const count = cart.reduce((s, i) => s + i.qty, 0);
    if (itemCountEl) itemCountEl.textContent = count;
    if (subtotalEl) subtotalEl.textContent = formatVND(getSubtotal());

    const discountDisplayRow = document.getElementById('discount-display-row');
    const discountValEl = document.getElementById('discount-val');
    if (discountDisplayRow && discountValEl) {
        if (getDiscount() > 0) {
            discountDisplayRow.style.setProperty('display', 'flex', 'important');
            discountValEl.textContent = '-' + formatVND(getDiscount());
        } else {
            discountDisplayRow.style.setProperty('display', 'none', 'important');
        }
    }

    if (totalEl) totalEl.textContent = formatVND(getTotal());
}

// Gửi thông tin đơn hàng lên hệ thống để lưu
function submitOrder() {
    if (cart.length === 0) {
        alert('Vui lòng chọn món trước khi thanh toán');
        return;
    }

    const tableId = document.getElementById('table-select')?.value || 1;
    const discount = getDiscount();
    const note = document.getElementById('order-note')?.value || '';
    const total = getTotal();

    const orderData = {
        tableId,
        discount,
        total,
        note,
        items: cart.map(item => ({
            productId: item.productId,
            quantity: item.qty,
            unitPrice: item.price,
            subtotal: item.price * item.qty
        }))
    };

    submitOrderForm(orderData);
}

// Tạo biểu mẫu ẩn để chuyển dữ liệu đơn hàng và lưu
function submitOrderForm(orderData) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = (window.APP_CONTEXT || '') + '/order';

    addHiddenField(form, 'action', 'createOrder');
    addHiddenField(form, 'tableId', orderData.tableId);
    addHiddenField(form, 'discount', orderData.discount);
    addHiddenField(form, 'total', orderData.total);
    addHiddenField(form, 'note', orderData.note);
    addHiddenField(form, 'itemsJson', JSON.stringify(orderData.items));

    document.body.appendChild(form);
    form.submit();
}

// Thêm các ô nhập dữ liệu ẩn vào biểu mẫu
function addHiddenField(form, name, value) {
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = name;
    input.value = value;
    form.appendChild(input);
}

// Tìm kiếm món
function searchMenu(keyword) {
    searchKeyword = (keyword || '').toLowerCase().trim();
    filterMenuItems();
}

// Lọc món theo danh mục
function filterByCategory(categoryId, btn) {
    currentCategory = String(categoryId || 'all');
    document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
    btn?.classList.add('active');
    filterMenuItems();
}

// Ẩn hiện món theo bộ lọc
function filterMenuItems() {
    const cards = document.querySelectorAll('.menu-item-wrapper');
    cards.forEach(card => {
        const name = (card.dataset.name || '').toLowerCase();
        const category = String(card.dataset.category || 'all');
        const matchCat = currentCategory === 'all' || category === currentCategory;
        const matchSearch = !searchKeyword || name.includes(searchKeyword);
        card.style.display = (matchCat && matchSearch) ? '' : 'none';
    });
}

// Hàm hiển thị thông báo bật lên (popup) nhỏ trên màn hình
function showToast(message, type = 'toast-added') {
    // Xóa thông báo cũ nếu có
    document.querySelectorAll('.toast').forEach(t => t.remove());
    
    // Tạo thẻ div hiển thị thông báo
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.innerHTML = `<span>${type === 'toast-added' ? '✅' : '❌'}</span> <span>${message}</span>`;
    document.body.appendChild(toast);
    
    // Cho hiện thông báo
    setTimeout(() => {
        toast.classList.add('show');
    }, 50);
    
    // Tự động xóa thông báo sau 2.2 giây
    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 400);
    }, 2200);
}

// Chạy khi trang web load xong
document.addEventListener('DOMContentLoaded', function () {
    loadCart(); // Tải lại giỏ hàng đã lưu
    
    // Kiểm tra xem có thông báo từ hệ thống không
    if (window.POS_SUCCESS_MESSAGE) {
        localStorage.removeItem('sun_coffee_cart');
        cart = [];
        saveCart();
        showToast(window.POS_SUCCESS_MESSAGE, 'toast-added');
    } else if (window.POS_ERROR_MESSAGE) {
        showToast(window.POS_ERROR_MESSAGE, 'toast-error');
    }
    renderCart(); // Vẽ giỏ hàng lên giao diện
});
