$(document).on('turbolinks:load', function() {
        initializers();

        $("#employee_caliber_12").change(function(){
                enableDropDown(this, document.getElementById("employee_calibers_12_quantity"));
        });

        $("#employee_caliber_38").change(function(){
                enableDropDown(this, document.getElementById("employee_calibers_38_quantity"));
        });

        $("#employee_munition_12").change(function(){
                enableDropDown(this, document.getElementById("employee_munitions_12_quantity"));
        });

        $("#employee_munition_38").change(function(){
                enableDropDown(this, document.getElementById("employee_munitions_38_quantity"));
        });

        $("#employee_waistcoat").change(function(){
                enableDropDown(this, document.getElementById("employee_waistcoats_quantity"));
        });

        $("#employee_radio").change(function(){
                enableDropDown(this, document.getElementById("employee_radios_quantity"));
        });

        $("#employee_vehicle").change(function(){
                enableDropDown(this, document.getElementById("employee_vehicles_quantity"));
        });

        $("#mountItemsListBtn").click(function(){
                var missionItens = {
                        calibers_12_quantity: document.getElementById("employee_calibers_12_quantity").value,
                        calibers_38_quantity: document.getElementById("employee_calibers_38_quantity").value,
                        munitions_12_quantity: document.getElementById("employee_munitions_12_quantity").value,
                        munitions_38_quantity: document.getElementById("employee_munitions_38_quantity").value,
                        waistcoats_quantity: document.getElementById("employee_waistcoats_quantity").value,
                        radios_quantity: document.getElementById("employee_radios_quantity").value,
                        vehicles_quantity: document.getElementById("employee_vehicles_quantity").value
                }

                $.ajax({
                        url: "/gestao/operador/dashboard/gerenciamento/mount_items_list",
                        type: "POST",
                        data: { items: missionItens },
                        success: function(data, status, xhr) {
                                populateLabel(data.descriptive_items['calibers12'], document.getElementById("chosenCaliber12"), "<i>Calibre 12 (Espingarda): </i>");
                                populateLabel(data.descriptive_items['calibers38'], document.getElementById("chosenCaliber38"), "<i>Calibre 38 (Pistola): </i>");
                                populateLabel(data.descriptive_items['munitions12'], document.getElementById("chosenMunition12"), "<i>Munição Calibre 12: </i>");
                                populateLabel(data.descriptive_items['munitions38'], document.getElementById("chosenMunition38"), "<i>Munição Calibre 38: </i>");
                                populateLabel(data.descriptive_items['waistcoats'], document.getElementById("chosenWaistcoat"), "<i>Colete: </i>");
                                populateLabel(data.descriptive_items['radios'], document.getElementById("chosenRadio"), "<i>Rádio: </i>");
                                populateLabel(data.descriptive_items['vehicles'], document.getElementById("chosenVehicle"), "<i>Viatura: </i>");
                        },
                        error: function(xhr, status, error) {
                                console.log(error);
                        }
                })
        });

});

function populateLabel(newItemData, label, defaultLabel) {
        label.innerHTML = defaultLabel;

        label.innerHTML = "<i><strong>" + label.textContent + "</strong>" + newItemData + "</i>";
}

function enableDropDown(checkBox, dropDown) {
        var itemSwitch = true;

        checkBox.checked ? itemSwitch = false : dropDown.value = 0;

        dropDown.disabled = itemSwitch;
}

function switchActionsButtons(action) {
        document.getElementById("confirmItemsListBtn").style.visibility = action;
        document.getElementById("clearItemsListBtn").style.visibility = action;
}

function initializers() {
        document.getElementById("employee_calibers_12_quantity").disabled = true;
        document.getElementById("employee_calibers_38_quantity").disabled = true;
        document.getElementById("employee_munitions_12_quantity").disabled = true;
        document.getElementById("employee_munitions_38_quantity").disabled = true;
        document.getElementById("employee_waistcoats_quantity").disabled = true;
        document.getElementById("employee_radios_quantity").disabled = true;
        document.getElementById("employee_vehicles_quantity").disabled = true;

        switchActionsButtons("hidden");
}
