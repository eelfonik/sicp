;计算阶乘
(define (factorial x)
	(if (> x 1)
		(* x (factorial (- x 1)))
		x
		))

; tail recursion ?
(define (factorial1 x)
	(define (factorial_iter product counter)
		(if (> counter x)
			product
			(factorial_iter (* product counter) (+ 1 counter))))
	(factorial_iter 1 1))

; you can even define your own + operator...
(define (+ a b)
  (if (= a 0)
    b
    (inc (+ (dec a) b))))

; 计算x的n次方
(define (root x n)
  (if (= n 0)
    1
    (* x (root x (- n 1)))
  ))

; fibonacci数列
; this is a tree-recursion, as every time it will call itself 2 times
; where the number of steps grows exponentially with n
; and the space required is linear with n
(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1)) (fib (- n 2))))))

; a better iterative vesion where the number of steps is linear to n
(define (fib1 n)
  (define (fib_iter previous previous2 count)
    (if (= count 0)
      previous2
      (fib_iter (+ previous previous2) previous (- count 1))
    )
  )
  (fib_iter 1 0 n)
)

; change coins for any given amount x (1 = 100)
; coin 50, 25, 10, 5, 1
; return how many ways of changes we have
; which equals to 1.make change with only one kind of coin, plus 2.make change without using any of that kind of coin
; the 1st equals to ways to make change of the remaining amount using all kinds of coin 
; how to calculate the remaining amount?
; minus amount with amount used with only that kind of coin
(define (changeCoin x)
  (define (countCoin x kind_of_coins)
    ; if remaining amount is 0
    (cond ((= x 0) 1)
    ; if remaining amount is less than 0 or we ran out of kind of coins
      ((or (< x 0) (= kind_of_coins 0)) 0)
      ; as kind_of_coins and x are free variables inside the countCoin procedure
      ; it will change value in next call
      (else (+ (countCoin x (- kind_of_coins 1)) (countCoin (- x (usedX kind_of_coins)) kind_of_coins)))
      )
  )
  ; the assumption here is the first time we use the coin with largest value (only use one coin?)
  ; then go down to coins with smaller value  
  (define (usedX kind_of_coins)
    (cond ((= kind_of_coins 1) 1)
      ((= kind_of_coins 2) 5)
      ((= kind_of_coins 3) 10)
      ((= kind_of_coins 4) 25)
      ((= kind_of_coins 5) 50))
  )
  (countCoin x 5)
)
; TODO: find a better algo as the above process is using too much space & time

; Exercise 1.11
; f(n) = n if n<3 and f(n) = f(n - 1) + 2f(n - 2) + 3f(n - 3) if n> 3.
; recursive process
(define (f n)
  (cond ((< n 3) n)
    (else (+ (f (- n 1)) (+ (* 2 (f (- n 2))) (* 3 (f (- n 3))))))))

; iterative process
(define (f1 n)
  (define (f1_iter fn1 fn2 fn3 counter)
    (cond 
      ((< counter 3) fn1)
      (else (f1_iter (+ fn1 (+ (* 2 fn2) (* 3 fn3))) fn1 fn2 (- counter 1)))))
  (if (< n 3)
    n
    (f1_iter 2 1 0 n))
)

; Exercise 1.12 Pascal's triangle
; x is the x th el in a row, start from 0
; y is the y th row, also start from 0
(define (pascal x y)
  (cond ((or (= x 0) (= x y)) 1)
    (else (+ (pascal (- x 1) (- y 1)) (pascal x (- y 1))))))

; Exercise 1.16
; exponentially
; recursive version with successive squaring
;如果n是偶数则直接计算n/2的平方，如果为奇数则 b*exp b（- n 1)
; which has log(n) of order of growth in both space and time
(define (exp b n)
  (cond ((= n 0) 1)
    ((even n) (square (exp b (/ n 2))))
    (else (* b (exp b (- n 1))))
    ))
(define (even x)
  (= (remainder x 2) 0))

; iterative version
; Using the observation that (bn/2)2 = (b2)n/2,
; keep, along with the exponent n and the base b, an additional state variable a,
; and define the state transformation in such a way that the product a bn is unchanged from state to state.
; At the beginning of the process a is taken to be 1,
; and the answer is given by the value of a at the end of the process.
; In general, the technique of defining an invariant quantity that remains unchanged from state to state is a powerful way to think about the design of iterative algorithms

; 如果是偶数就先把base做个二次方。。。 simple
(define (fast-exp b n)
  (define (exp_iter base product counter)
    (cond ((= counter 0) product)
      ((even counter) (exp_iter (square base) product (/ counter 2)))
      (else (exp_iter base (* product base) (- counter 1)))
      ))
  (exp_iter b 1 n)
)

; Exercise 1.17
(define (double x)
  (+ x x))

(define (halve x)
  (/ x 2))

(define (multiply x y)
  (cond ((= y 0) 0)
    ((even y) (double (multiply x (halve y))))
    (else (+ x (multiply x (- y 1))))
  )
)
; note that the above algo use log(n) steps
; but as it's a recursive version, it takes theta(n) in space

; exercise 1.18
; 上述方程的iterative process
; the same as 1.16: we double the x if y is even
; this procedure is theta(log(n)) in steps
; and theta(1) in spaces
(define (better-multiply x y)
  (define (multi-iter x y product)
    (cond ((= y 0) product)
      ((even y) (multi-iter (double x) (halve y) product))
      (else (multi-iter x (- y 1) (+ x product)))
    )
  )
  (multi-iter x y 0)
)

; Exercise 1.19
; log(n) steps of fibonacci
; we can consider it as a single dimension martix multiply
; take (a, b) as a (2,1) sahpe of vector, with initial value (1,0)
; and (p, q) as a (1,2) verctor, with init value (0,1)
; notation: a[n]/b[n] refers to a/b in group n
; a[n] = a[n-1] + b[n-1] = 0 * a[n-1] + 1 * (a[n-1] + b[n-1]) = p*a[n-1] + q*(a[n-1]+b[n-1])
; b[n] = a[n-1] = 0* b[n-1] + 1 * a[n-1] = p*b[n-1] + q*a[n-1]
; we need a new pair of (p', q') that makes both
; a[2n] = P'*a[n] +q'*(a[n] + b[n])
; b[2n] = p'*b[n]+q'a[n]
; where (p', q') is transformed from the previous (p,q)
; that has the same result as applying the tranform twice
; if we define the transform as Tpq
; we have Tpq(Tpq(a,b)) = Tp'q'(a,b)
; => Tpq(p*a+q*(a+b), p*b+q*a) = Tp'q'(a,b)
; => (p*(p*a+q*(a+b))+q*(p*a+q*(a+b)+p*b+q*a), p*(p*b+q*a)+q*(p*a+q*(a+b))) = Tp'q'(a,b)
; => we can find that p'= p*p+q*q, and q' = q*q + 2*p*q 
(define (fast-fib n)
  (define (fib-iter a b p q count)
    (cond ((= count 0) b)
      ((even count) (fib-iter a b (+ (* p p) (* q q)) (+ (* q q) (* 2 p q)) (/ count 2)))
      (else (fib-iter (+ (* p a) (* q (+ a b))) (+ (* p b) (* q a)) p q (- count 1)))
    ))
  (fib-iter 1 0 0 1 n)
)

; Exercise 1.21
; with theta(square-root n) steps
(define (smallest-divisor x)
  (define (find-divisor num divisor)
      (cond ((> (square divisor) num) num)
        ((divided num divisor) divisor)
        (else (find-divisor num (+ divisor 1)))
      )
  )
  (define (divided a b)
    (= (remainder a b) 0))
  (find-divisor x 2)
)

(define (prime? n)
  (= (smallest-divisor n) n))

; Exercise 1.22
; note: the following 3 funcs provided in the book are not correct
; `display` does not return anything (in fact it's `Unspecified return value`)
; So inside `start-prime-test` procedure, we need to return false (`#f`) if the number is not prime
; and inside `report-prime`, we need to return true (`#t`)
; otherwise the `if (timed-prime-test n)` will always execute the consequent, and will never reach alternative 
(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))
      #f
    ))

; we don't need return `#t` here
; but I don't like the `Unspecified return value` message...
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time)
  #t
)

;prime in range
;find the first 3 smallest primes that larger than the start point
(define (search-for-primes start-range)
  (define (search-for-primes-iter n counter)
    (if (> counter 0)
        (if (timed-prime-test n)
            (search-for-primes-iter (+ n 2) (- counter 1))
            (search-for-primes-iter (+ n 1) counter)
        )
        " COMPLETE "
    )
  )
  (search-for-primes-iter start-range 3)
)

; Exercise 1.23
; faster `smallest-divisor`
; if a num cannot be divided by 2, then we don't need to test any even divisor
(define (smallest-divisor n)
	(define (find-divisor num divisor)
		(cond ((> (square divisor) num) num)
			((= (remainder num divisor) 0) divisor)
			(else (find-divisor num (addDivisor divisor)))
		)
	)
	(define (addDivisor divisor)
		(if (= divisor 2)
			(+ divisor 1)
			(+ divisor 2)))
	(find-divisor n 2)
)

; Exercise 1.24
; the procedure expmod computes the exponential(exp) of a number(base) modulo another number(n)
; 如果是0次方，则任何数的0次方都是1，而1除以任何数的余数都是1
; 如果是偶数次方，则可以调用平方(square), 直接把次方数除2，可以大幅减少运算步数
(define (expmod base exp m)
  (cond ((= exp 0) 1)
		((even? exp) (remainder (square (expmod base (/ exp 2) m)) m))
		(else (remainder (* base (expmod base (- exp 1) m)) m))
	)
)

; randomly take a number between 1 and (n-1) to test
(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
	(try-it (+ 1 (random (- n 1))))
)

(define (fast-prime? n times)
  (cond ((= times 0) true)
		((fermat-test n) (fast-prime? n (- times 1)))
		(else false)
	)
)

(define (prime? n)
	(fast-prime? n 100))


; Exercise 1.27
; Demonstrate that the Carmichael numbers really DO fool the Fermat test
; instead of randomly choose some number, we need to test every a that is smaller than n
(define (exhausted-fermat-test n)
	(define (carmichel-test-iter a n)
		(cond ((and (= (expmod a n n) a) (< a n)) (carmichel-test-iter (+ a 1) n))
			((= a n) true)
			(else false)
		)
	)
	(carmichel-test-iter 1 n)
)

; Exercise 1.28
; Miller-Rabin test (that cannot be fooled by Carmichael numbers)
; The remainder of a number a when divided by n is also referred to as the remainder of a modulo n
; or simply as a modulo n. 即 a/n 的余数

; if n is a prime number and a is any positive integer less than n,
; then a raised to the (n - 1)st power is congruent to 1 modulo n.
; To test the primality of a number n by the Miller-Rabin test,
; we pick a random number a<n and raise a to the (n - 1)st power modulo n using the expmod procedure.
; However, whenever we perform the squaring step in expmod,
; we check to see if we have discovered a "nontrivial square root of 1 modulo n",
; that is, a number not equal to 1 or n - 1 whose square is congruent to 1 modulo n.
; It is possible to prove that if such a nontrivial square root of 1 exists, then n is not prime.
; It is also possible to prove that if n is an odd number that is not prime, then,
; for at least half the numbers a<n, computing a[n-1] in this way will reveal a nontrivial square root of 1 modulo n.
(define (nontrivial-number n m)
  (cond ((= n 1) false)
    ((= n (- m 1)) false)
    ; whose square is congruent to 1 modulo n
    (else (= (remainder (square n) m) 1))
  )
)

(define (miller-expmod base exp m)
  (cond ((= exp 0) 1)
    ((even? exp)
      ; calculate the number that will be used to do the square
      ; and check if THIS number is a nontrivial square root of 1 modulo n
      (if (nontrivial-number (miller-expmod base (/ exp 2) m) m)
        0
        (remainder (square (miller-expmod base (/ exp 2) m)) m)))
		(else (remainder (* base (miller-expmod base (- exp 1) m)) m))
	)
)

(define (miller-rabin-test n)
  (define (test-iter a n)
    (cond ((= a 0) true)
      ((= (miller-expmod a (- n 1) n) 1) (try-iter (- a 1) n))
      (else false)
    )
  )
  (test-iter (- n 1) n)    
)
