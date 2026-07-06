function openModal(id){const el=document.getElementById(id);if(el)el.classList.add('show');}
function closeModal(id){const el=document.getElementById(id);if(el)el.classList.remove('show');}
function closeOnBackdrop(e,id){if(e.target && e.target.id===id) closeModal(id);}
function confirmDelete(formId, name){
  let msg = 'B\u1ea1n c\u00f3 ch\u1eafc ch\u1eafn mu\u1ed1n x\u00f3a?';
  if (formId.startsWith('del-emp')) {
    msg = `B\u1ea1n c\u00f3 ch\u1eafc ch\u1eafn mu\u1ed1n x\u00f3a nh\u00e2n vi\u00ean:\n${name}`;
  } else if (formId.startsWith('del-order')) {
    msg = `B\u1ea1n c\u00f3 ch\u1eafc ch\u1eafn mu\u1ed1n x\u00f3a \u0111\u01a1n h\u00e0ng:\n${name}`;
  } else if (formId.startsWith('cancel-order')) {
    msg = `B\u1ea1n c\u00f3 ch\u1eafc ch\u1eafn mu\u1ed1n h\u1ee7y \u0111\u01a1n h\u00e0ng:\n${name}`;
  } else if (formId.startsWith('del-product')) {
    msg = `B\u1ea1n c\u00f3 ch\u1eafc ch\u1eafn mu\u1ed1n x\u00f3a s\u1ea3n ph\u1ea9m:\n${name}`;
  } else if (formId.startsWith('del-cat')) {
    msg = `B\u1ea1n c\u00f3 ch\u1eafc ch\u1eafn mu\u1ed1n x\u00f3a danh m\u1ee5c:\n${name}`;
  } else if (formId.startsWith('del-item')) {
    msg = `B\u1ea1n c\u00f3 ch\u1eafc ch\u1eafn mu\u1ed1n x\u00f3a nguy\u00ean li\u1ec7u:\n${name}`;
  }
  if (confirm(msg)) {
    document.getElementById(formId)?.submit();
  }
}

function searchTable(keyword, tableId, colIndex){
  const table=document.getElementById(tableId); if(!table) return;
  const kw=(keyword||'').toLowerCase().trim();
  [...table.tBodies[0].rows].forEach(row=>{
    const text=(row.cells[colIndex]?.innerText||'').toLowerCase();
    row.style.display=text.includes(kw)?'':'none';
  });
}
function filterTable(value, tableId, colIndex){
  const table=document.getElementById(tableId); if(!table) return;
  const val=(value||'').toLowerCase().trim();
  [...table.tBodies[0].rows].forEach(row=>{
    if(!val){row.style.display='';return;}
    const text=(row.cells[colIndex]?.innerText||'').toLowerCase();
    row.style.display=text.includes(val)?'':'none';
  });
}

function setInvalid(input, msg){
  if(!input) return;
  input.classList.add('is-invalid');
  const fb=input.parentElement?.querySelector('.invalid-feedback');
  if(fb){fb.textContent=msg;fb.style.display='block';}
}
function clearInvalid(form){form.querySelectorAll('.is-invalid').forEach(i=>i.classList.remove('is-invalid'));form.querySelectorAll('.invalid-feedback').forEach(f=>{f.textContent='';f.style.display='none';});}

function validateProductForm(formId){
  const form=document.getElementById(formId); if(!form) return;
  clearInvalid(form); let ok=true;
  const name=form.querySelector('[name="productName"]');
  const price=form.querySelector('[name="price"]');
  const category=form.querySelector('[name="categoryId"]');
  if(!name.value.trim()){setInvalid(name,'Vui l\u00f2ng nh\u1eadp t\u00ean s\u1ea3n ph\u1ea9m');ok=false;}
  if(!price.value || Number(price.value)<0){setInvalid(price,'Gi\u00e1 b\u00e1n kh\u00f4ng h\u1ee3p l\u1ec7');ok=false;}
  if(!category.value){setInvalid(category,'Vui l\u00f2ng ch\u1ecdn danh m\u1ee5c');ok=false;}
  return ok;
}
function validateCategoryForm(formId){
  const form=document.getElementById(formId); if(!form) return;
  clearInvalid(form); let ok=true;
  const name=form.querySelector('[name="categoryName"]');
  if(!name.value.trim()){setInvalid(name,'Vui l\u00f2ng nh\u1eadp t\u00ean danh m\u1ee5c');ok=false;}
  return ok;
}
function previewImage(input, previewId){
  const img=document.getElementById(previewId); if(!img) return;
  const value=(input.value||'').trim();
  if(!value){img.style.display='none';return;}
  img.src = value.startsWith('http') ? value : ((window.APP_CONTEXT || '') + '/assets/images/' + value);
  img.style.display='block';
}
function getCanvasData(canvas){
  try{return {labels:JSON.parse(canvas.dataset.labels||'[]'), values:JSON.parse(canvas.dataset.values||'[]')}}
  catch(e){return {labels:[], values:[]};}
}
function drawChart(id, type){
  const canvas=document.getElementById(id);
  if(!canvas || typeof Chart==='undefined') return;
  const data=getCanvasData(canvas);
  const isPie = type==='pie' || type==='doughnut';
  new Chart(canvas,{
    type,
    data:{
      labels:data.labels,
      datasets:[{
        label:'Gi\u00e1 tr\u1ecb',
        data:data.values,
        borderWidth: type==='line' ? 3 : 1,
        tension: .35
      }]
    },
    options:{
      responsive:true,
      maintainAspectRatio:false,
      plugins:{
        legend:{display:isPie, position:'top'},
        tooltip:{enabled:true}
      },
      scales:isPie ? {} : {
        x:{ticks:{font:{size:11}, maxRotation:0, autoSkip:true}},
        y:{beginAtZero:true, ticks:{font:{size:11}}}
      }
    }
  });
}
document.addEventListener('DOMContentLoaded',()=>{
  drawChart('chart-revenue','line');
  drawChart('chart-category','doughnut');
  drawChart('chart-top-products','bar');
});

function searchAnyTable(keyword, tableId){
  const table=document.getElementById(tableId); if(!table || !table.tBodies[0]) return;
  const kw=(keyword||'').toLowerCase().trim();
  [...table.tBodies[0].rows].forEach(row=>{
    row.style.display=row.innerText.toLowerCase().includes(kw)?'':'none';
  });
}
function fillFormFromDataset(form, data){
  Object.keys(data).forEach(key=>{
    const input=form.querySelector(`[name="${key}"]`);
    if(input) input.value=data[key] ?? '';
  });
}
document.addEventListener('click', e=>{
  const emp=e.target.closest('.js-edit-employee');
  if(emp){
    const form=document.getElementById('form-edit-employee'); if(!form) return;
    fillFormFromDataset(form,{id:emp.dataset.id,employeeCode:emp.dataset.code,fullName:emp.dataset.name,phone:emp.dataset.phone,email:emp.dataset.email,role:emp.dataset.role,shift:emp.dataset.shift,salary:emp.dataset.salary,status:emp.dataset.status});
    openModal('modal-edit-employee');
  }
  const item=e.target.closest('.js-edit-item');
  if(item){
    const form=document.getElementById('form-edit-item'); if(!form) return;
    fillFormFromDataset(form,{id:item.dataset.id,itemName:item.dataset.name,unit:item.dataset.unit,quantity:item.dataset.quantity,minQuantity:item.dataset.min,supplier:item.dataset.supplier,status:item.dataset.status});
    openModal('modal-edit-item');
  }
  const cat=e.target.closest('.js-edit-cat');
  if(cat){
    const form=document.getElementById('form-edit-category'); if(!form) return;
    fillFormFromDataset(form,{categoryId:cat.dataset.id,categoryName:cat.dataset.name,description:cat.dataset.description});
    openModal('modal-edit-category');
  }
  const prod=e.target.closest('.js-edit-product');
  if(prod){
    const form=document.getElementById('form-edit-product'); if(!form) return;
    fillFormFromDataset(form,{productId:prod.dataset.id,productName:prod.dataset.name,price:prod.dataset.price,categoryId:prod.dataset.categoryId,description:prod.dataset.description,image:prod.dataset.image,status:prod.dataset.status});
    previewImage(form.image,'edit-img-preview');
    openModal('modal-edit-product');
  }
  const adj=e.target.closest('.js-adjust-stock');
  if(adj){
    const form=document.getElementById('form-adjust-stock'); if(!form) return;
    form.id.value=adj.dataset.id;
    document.getElementById('adjust-item-name').value=adj.dataset.name;
    document.getElementById('adjust-current-qty').value=adj.dataset.quantity;
    form.quantity.value=adj.dataset.quantity;
    openModal('modal-adjust-stock');
  }
});
