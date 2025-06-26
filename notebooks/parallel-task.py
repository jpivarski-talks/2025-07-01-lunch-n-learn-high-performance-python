import threading
import time
import sys

import numpy as np

NUM_THREADS = int(sys.argv[1])
DATASET_SIZE = 5_000_000

a_list = np.random.uniform(5, 10, DATASET_SIZE).tolist()
b_list = np.random.uniform(10, 20, DATASET_SIZE).tolist()
c_list = np.random.uniform(-0.1, 0.1, DATASET_SIZE).tolist()

output = [None] * DATASET_SIZE


def some_work(index):
    "Compute the quadratic formula on 1/NUM_THREADS of the data."

    chunk_size = len(a_list) // NUM_THREADS
    start = index * chunk_size
    stop = (index + 1) * chunk_size
    if index == NUM_THREADS - 1:
        stop = len(a_list)

    for i in range(start, stop):
        assert output[i] is None, "an item was computed more than once"
        a, b, c = a_list[i], b_list[i], c_list[i]
        output[i] = (-b + np.sqrt(b**2 - 4 * a * c)) / (2 * a)


threads = [
    threading.Thread(target=some_work, args=(index,)) for index in range(NUM_THREADS)
]

start_time = time.time()

# start all the threads at roughly the same time
for thread in threads:
    thread.start()

# wait for all the threads to finish
for thread in threads:
    thread.join()

print(f"{NUM_THREADS} worker finished in {time.time() - start_time:.1f} seconds")

assert all(x is not None for x in output), "some items were not computed"
