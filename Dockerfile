FROM jupyter/base-notebook:python-3.11

COPY notebooks/ /home/jovyan/notebooks/

RUN pip install --no-cache-dir jupyterlab-deck

EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--notebook-dir=/home/jovyan/notebooks", "/home/jovyan/notebooks/presentation.ipynb"]
