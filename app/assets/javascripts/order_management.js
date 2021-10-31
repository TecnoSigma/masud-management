$(document).on('turbolinks:load', function() {
        var missionInfo = {};

        initializers();

        $("#order_agents_quantity").change(function(){
                if (document.getElementById("order_agents_quantity").value == '0') {
                        document.getElementById("teamLabel").innerHTML = "<i>Nome do Time: </i>";
                        document.getElementById("agentsLabel").innerHTML = "<i>Agentes: </i>";

                        switchTeamActionsButtons("none");
                }
        });

        $("#order_caliber_12").change(function(){
                enableDropDown(this, document.getElementById("order_calibers_12_quantity"));
        });

        $("#order_caliber_38").change(function(){
                enableDropDown(this, document.getElementById("order_calibers_38_quantity"));
        });

        $("#order_munition_12").change(function(){
                enableDropDown(this, document.getElementById("order_munitions_12_quantity"));
        });

        $("#order_munition_38").change(function(){
                enableDropDown(this, document.getElementById("order_munitions_38_quantity"));
        });

        $("#order_waistcoat").change(function(){
                enableDropDown(this, document.getElementById("order_waistcoats_quantity"));
        });

        $("#order_radio").change(function(){
                enableDropDown(this, document.getElementById("order_radios_quantity"));
        });

        $("#order_vehicle").change(function(){
                enableDropDown(this, document.getElementById("order_vehicles_quantity"));
        });

        $('#confirmOrderBtn').click(function(){
                var order_number = window.location.pathname.split('/').slice(-1)[0];

                missionInfo.order_number = order_number;

                $.ajax({
                        url: "/gestao/operador/dashboard/gerenciamento/confirm_order",
                        type: "POST",
                        data: { mission_info: missionInfo },
                        success: function(data, status, xhr) {
                        },
                        error: function(xhr, status, error) {
                                console.log(error);
                        }
                });
        });

        $("#mountTeamBtn").click(function(){
                if (document.getElementById("order_agents_quantity").value == '0') return

                var agentsQuantity = { quantity: document.getElementById("order_agents_quantity").value };

                $.ajax({
                        url: "/gestao/operador/dashboard/gerenciamento/mount_team",
                        type: "POST",
                        data: { agent: agentsQuantity },
                        success: function(data, status, xhr) {
                                populateLabel(data.team['team_name'], document.getElementById("teamLabel"), "<i>Nome do Time: </i>");
                                populateLabel(data.team['agents'], document.getElementById("agentsLabel"), "<i>Agentes: </i>");

                                switchTeamActionsButtons('');

                                missionInfo.team = data.team;

                                document.getElementById("mountTeamBtn").style.display = "none";
                        },
                        error: function(xhr, status, error) {
                                console.log(error);
                        }
                });
        });

        $('#clearItemsListBtn').click(function(){
                enableDropDown(this, document.getElementById("order_calibers_12_quantity"));
                enableDropDown(this, document.getElementById("order_calibers_38_quantity"));
                enableDropDown(this, document.getElementById("order_munitions_12_quantity"));
                enableDropDown(this, document.getElementById("order_munitions_38_quantity"));
                enableDropDown(this, document.getElementById("order_waistcoats_quantity"));
                enableDropDown(this, document.getElementById("order_radios_quantity"));
                enableDropDown(this, document.getElementById("order_vehicles_quantity"));

                $('#order_caliber_12').prop( "checked", false);
                $('#order_caliber_38').prop("checked", false);
                $('#order_munition_12').prop("checked", false);
                $('#order_munition_38').prop("checked", false);
                $('#order_waistcoat').prop("checked", false);
                $('#order_radio').prop("checked", false);
                $('#order_vehicle').prop("checked", false);

                document.getElementById("chosenCaliber12").innerHTML = "<i>Calibre 12 (Espingarda): </i>";
                document.getElementById("chosenCaliber38").innerHTML = "<i>Calibre 38 (Pistola): </i>";
                document.getElementById("chosenMunition12").innerHTML = "<i>Munição Calibre 12: </i>";
                document.getElementById("chosenMunition38").innerHTML = "<i>Munição Calibre 38: </i>";
                document.getElementById("chosenWaistcoat").innerHTML = "<i>Colete: </i>";
                document.getElementById("chosenRadio").innerHTML = "<i>Rádio: </i>";
                document.getElementById("chosenVehicle").innerHTML = "<i>Viatura: </i>";

                switchItemsActionsButtons("none");
        });

        $('#confirmItemsListBtn').click(function(){
                document.getElementById("order_caliber_12").disabled = true;
                document.getElementById("order_caliber_38").disabled = true;
                document.getElementById("order_munition_12").disabled = true;
                document.getElementById("order_munition_38").disabled = true;
                document.getElementById("order_waistcoat").disabled = true;
                document.getElementById("order_radio").disabled = true;
                document.getElementById("order_vehicle").disabled = true;

                document.getElementById("order_calibers_12_quantity").disabled = true;
                document.getElementById("order_calibers_38_quantity").disabled = true;
                document.getElementById("order_munitions_12_quantity").disabled = true;
                document.getElementById("order_munitions_38_quantity").disabled = true;
                document.getElementById("order_waistcoats_quantity").disabled = true;
                document.getElementById("order_radios_quantity").disabled = true;
                document.getElementById("order_vehicles_quantity").disabled = true;

                document.getElementById("mountItemsListBtn").style.display = "none";

                switchItemsActionsButtons("none");

                document.getElementById("itemConfirmation").style.display = "";

                showConfirmOrderBtn();

                missionInfo.descriptive_items = data.descriptive_items;
        });

        $("#mountItemsListBtn").click(function(){
                var missionItens = {
                        calibers_12_quantity: document.getElementById("order_calibers_12_quantity").value,
                        calibers_38_quantity: document.getElementById("order_calibers_38_quantity").value,
                        munitions_12_quantity: document.getElementById("order_munitions_12_quantity").value,
                        munitions_38_quantity: document.getElementById("order_munitions_38_quantity").value,
                        waistcoats_quantity: document.getElementById("order_waistcoats_quantity").value,
                        radios_quantity: document.getElementById("order_radios_quantity").value,
                        vehicles_quantity: document.getElementById("order_vehicles_quantity").value
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

                                switchItemsActionsButtons("");
                        },
                        error: function(xhr, status, error) {
                                console.log(error);
                        }
                })
        });

        $("#confirmTeamBtn").click(function(){
                switchTeamActionsButtons("none");

                showConfirmOrderBtn();

                document.getElementById("teamConfirmation").style.display = "";
        });

        $('#refuseTeamBtn').click(function(){
                const counter = 1;

                $.ajax({
                        url: "/gestao/operador/dashboard/gerenciamento/refuse_team",
                        type: "POST",
                        data: { counter: counter },
                        success: function(data, status, xhr) {
                                if (data.exceeded_attempts == true) {
                                        document.getElementById("refuseInfo").innerHTML = "<span style='color: red'>Quantidade de recusas excedidas. Solicite o desbloqueio ao Administrador.</span>";

                                        switchTeamActionsButtons("none");
                                        switchItemsActionsButtons("none");
                                        switchOrderButtons("none");

                                        document.getElementById("mountTeamBtn").style.display = "none";
                                        document.getElementById("mountItemsListBtn").style.display = "none";
                                        document.getElementById("order_agents_quantity").disabled = true;

                                        blockOrder();
                                } else {
                                        document.getElementById("mountTeamBtn").style.display = "";
                                        document.getElementById("refuseInfo").innerHTML = "<span style='color: gray''>" + data.attempts + "ª recusa</span>";
                                }
                        },
                        error: function(xhr, status, error) {
                                console.log(error);
                        }
                })
        });

});

function showConfirmOrderBtn() {
        if(document.getElementById("mountTeamBtn").style.display == "none" && document.getElementById("mountItemsListBtn").style.display == "none") {
                document.getElementById("confirmOrderBtn").style.display = "";
        }
}

function populateLabel(newItemData, label, defaultLabel) {
        label.innerHTML = defaultLabel;

        label.innerHTML = "<i><strong>" + label.textContent + "</strong>" + newItemData + "</i>";
}

function enableDropDown(checkBox, dropDown) {
        var itemSwitch = true;

        checkBox.checked ? itemSwitch = false : dropDown.value = 0;

        dropDown.disabled = itemSwitch;
}

function switchItemsActionsButtons(action) {
        document.getElementById("confirmItemsListBtn").style.display = action;
        document.getElementById("clearItemsListBtn").style.display = action;
}

function switchOrderButtons(action) {
        document.getElementById("confirmOrderBtn").style.display = action;
        document.getElementById("refuseOrderBtn").style.display = action;
}

function switchTeamActionsButtons(action) {
        document.getElementById("confirmTeamBtn").style.display = action;
        document.getElementById("refuseTeamBtn").style.display = action;
}

function blockOrder() {
        $.ajax({
                url: "/gestao/operador/dashboard/gerenciamento/block_order",
                type: "POST",
                data: { block: true },
                success: function(data, status, xhr) { },
                error: function(xhr, status, error) { console.log(error); }
        });
}

function hiddenMessages() {
        document.getElementById("teamConfirmation").style.display = "none";
        document.getElementById("itemConfirmation").style.display = "none";
}

function initializers() {
        document.getElementById("order_calibers_12_quantity").disabled = true;
        document.getElementById("order_calibers_38_quantity").disabled = true;
        document.getElementById("order_munitions_12_quantity").disabled = true;
        document.getElementById("order_munitions_38_quantity").disabled = true;
        document.getElementById("order_waistcoats_quantity").disabled = true;
        document.getElementById("order_radios_quantity").disabled = true;
        document.getElementById("order_vehicles_quantity").disabled = true;

        switchTeamActionsButtons("none");
        switchItemsActionsButtons("none");

        hiddenMessages();

        document.getElementById("confirmOrderBtn").style.display = "none";
}
