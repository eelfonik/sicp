;exe1.2
(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5))))) 
   (* 3 (- 6 2) (- 2 7)))

;exe1.3
(define (square x) (* x x))
(define (square_sum x y) (+ (square x) (square y)))
(define (find_larger x y) (if (or (> x y) (= x y)) x y))
(define (square_sum_larger_two x y z)
	(cond ((>= x y) (square_sum x (find_larger y z)))
		  (else (square_sum y (find_larger x z))))) 

;1.7的内容：计算根号

;这一段的n指定了循环几次，但不够好，需要有一个是否足够精确了的标准
(define (square_root x n) (guess x n 1.0))
(define (guess x n g) 
	(cond ((> n 0) (guess x (- n 1) (calcGuess x g)))
		(else g)))
(define (calcGuess x g) (/ (+ (/ x g) g) 2))

;alternative
;定义一个square的计算，然后再对比 square计算出来的平方根的结果，和x 之间的差距，如果小于0.001就认为guess足够好
;我们还应该定义一个sqrt的procedure,把手动输入guess的value这一步去掉,例如
; (define (sqrt x) (square_root_1 0.1 x))

(define (square_root_1 guess x) 
	(if (good_enough_1 guess x)
		guess
		(square_root_1 (improve_1 guess x) x)))
(define (improve_1 guess x)
	(/ (+ (/ x guess) guess) 2))
(define (good_enough_1 guess x)
	(< (abs (- (square guess) x)) 0.001))
(define (square x) (* x x))

;Exercise 1.7 make a better good_enough
;把guess的结果拿去跟last_guess相比，而不是x
(define (square_root_2 guess x) 
	(if (good_enough_2 (improve_2 guess x) guess)
		guess
		(square_root_2 (improve_2 guess x) x)))
(define (improve_2 guess x)
	(/ (+ (/ x guess) guess) 2))
(define (good_enough_2 guess last_guess)
	(<= (/ (abs (- guess last_guess)) guess) 0.0001))

;Exercise 1.8 cube roots
(define (cbrt x) (cube_root 0.1 x))
(define (cube_root guess x)
	(if (goodEnough (improveGuess guess x) guess)
		guess
		(cube_root (improveGuess guess x) x)))
(define (goodEnough next_guess guess)
	(< (/ (abs (- guess next_guess)) guess) 0.00001))
(define (improveGuess guess x)
	(/ (+ (/ x (* guess guess)) (* 2 guess)) 3))

;better sqrt with local names & internal definitions
(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))

;计算阶乘
(define (factorial x)
	(if (> x 1)
		(* x (factorial (- x 1)))
		x
		))

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
(define (exp1 b n)
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
