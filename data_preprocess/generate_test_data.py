cur_test = "./data/cur_test.txt"
ref_test = "./data/ref_test.txt"

with open(cur_test, "w") as f:
    for i in [t for t in range(1, 10)] + ["a", "b", "c", "d", "e", "f"]:
        for j in range(1, 9):
            for _ in range(8):
                f.write(str(f"{i}{j}" + "\n"))

with open(ref_test, "w") as f:
    for i in [t for t in range(1, 10)] + ["a", "b", "c", "d", "e", "f"]:
        for _ in range(23):
            for j in range(1, 9):
                f.write(str(f"{i}{j}" + "\n"))
