fib.py
```
def fibonacci(n):
    a, b = 0, 1
    seq = []
    for _ in range(n):
        seq.append(a)
        a, b = b, a + b
    return seq

if __name__ == "__main__":
    n = int(input("Enter the number of Fibonacci numbers to generate: "))
    print(fibonacci(n))
```
