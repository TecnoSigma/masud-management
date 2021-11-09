$(document).on('turbolinks:load', function() {
        $("#closeFinishMissionObservationModalBtn").click(function(){
                document.getElementById("finishMissionObservationModal").style.display = "none";
        });

        $("#finishMissionObservationModalBtn").click(function(){
                document.getElementById("finishMissionObservationModal").style.display = "block";
        });
});
