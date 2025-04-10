# Use Ubuntu 24.04 LTS como imagem base
FROM ubuntu:24.04

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    unzip \
    python3 \
    python3-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Cria um ambiente virtual em /venv, atualiza o pip e instala o Jupyter Notebook
RUN python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install notebook

# A biblioteca "unittest" já é parte da biblioteca padrão do Python,
# portanto não é necessário instalá-la.

# Configura os vim keybindings para o Jupyter Notebook
# Para isso, cria-se um arquivo custom.js no diretório de configuração do Jupyter
RUN mkdir -p /root/.jupyter/custom && \
    echo "require(['notebook/js/codecell'], function(codecell) { \
codecell.CodeCell.options_default.cm_config.keyMap = 'vim'; \
});" > /root/.jupyter/custom/custom.js

# Adiciona o diretório do ambiente virtual ao PATH, facilitando o uso dos executáveis instalados
ENV PATH="/venv/bin:${PATH}"

# Define o diretório de trabalho onde os notebooks serão armazenados
WORKDIR /notebooks

# Expõe a porta padrão do Jupyter Notebook
EXPOSE 8888

# Comando para iniciar o Jupyter Notebook com as opções necessárias
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--notebook-dir=/notebooks"]
