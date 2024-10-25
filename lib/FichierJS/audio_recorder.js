let mediaRecorder;
let audioChunks = [];

function startRecording() {
    navigator.mediaDevices.getUserMedia({ audio: true })
        .then(stream => {
            mediaRecorder = new MediaRecorder(stream);
            mediaRecorder.ondataavailable = event => {
                audioChunks.push(event.data);
            };
            mediaRecorder.onstop = () => {
                const audioBlob = new Blob(audioChunks, { type: 'audio/wav' });
                const audioUrl = URL.createObjectURL(audioBlob);
                audioChunks = []; // Réinitialiser pour la prochaine enregistrement
                return audioUrl; // Retourner l'URL de l'audio
            };
            mediaRecorder.start();
        });
}

function stopRecording() {
    mediaRecorder.stop();
}
