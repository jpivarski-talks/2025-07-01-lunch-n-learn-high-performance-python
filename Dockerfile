FROM python:3.13-slim

RUN apt-get update && apt-get install -y --no-install-recommends build-essential

RUN pip install --no-cache-dir jupyterlab jupyterlab-deck numpy numba jax pyarrow awkward pybind11

COPY notebooks/ /home/jovyan/notebooks/

EXPOSE 8888

CMD ["jupyter", "labextension", "disable", "\"@jupyterlab/apputils-extension:announcements\""]
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--no-browser", "--notebook-dir=/home/jovyan/notebooks", "/home/jovyan/notebooks/presentation.ipynb"]
