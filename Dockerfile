######## base image ##########
FROM cgr.dev/chainguard/wolfi-base:latest

LABEL maintaner="devops@marceleza.com"

# Diretório de trabalho
WORKDIR /app

# Instala dependências do sistema (Python + pip + bash)
RUN apk update && apk add --no-cache --update-cache \
    bash python3 py3-pip

# Cria usuário não-root para rodar o app
RUN adduser -D userflask
USER userflask

# Copia requirements e instala dependências
COPY requirements.txt .
RUN pip install --no-cache-dir --break-system-packages -r requirements.txt

# Copia todo o código da aplicação
COPY . .

# Define qual app o Flask deve rodar (ajuste se o arquivo não for app.py!)
ENV FLASK_APP=app.py

# Expõe a porta
EXPOSE 5000

# Evita depender do PATH e garante execução correta
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0"]

