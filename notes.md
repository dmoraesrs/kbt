resource "google_cloudfunctions_function" "pubsub_to_webhook" {
  name        = "send-to-webhook"
  runtime     = "python310"
  entry_point = "hello_pubsub"
  available_memory_mb = 128
  source_code {
    files = {
      "main.py" = <<-EOT
        import base64
        import functions_framework
        import json
        import os
        import requests

        @functions_framework.cloud_event
        def hello_pubsub(cloud_event):
            try:
                data = base64.b64decode(cloud_event.data["message"]["data"]).decode('utf-8')
                print(f'Decoded message: {data}')
                message = {"text": data}
                webhook_url = os.getenv("WEBHOOK_URL")
                response = requests.post(webhook_url, data=json.dumps(message), headers={'Content-Type': 'application/json'})
                if response.status_code == 200:
                    print(f'Mensagem enviada para o webhook com sucesso: {message}')
                else:
                    print(f'Falha ao enviar mensagem para o webhook. Código de status: {response.status_code}')
            except Exception as e:
                print(f'Erro ao processar mensagem: {e}')
        EOT
      "requirements.txt" = <<-EOT
        functions-framework
        requests
        EOT
    }
  }
  environment_variables = {
    WEBHOOK_URL = "https://example.com/webhook"  # Substitua pelo URL do seu webhook
  }
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.test_topic.id
  }
}
