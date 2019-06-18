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
;To avoid the problem with extreme small or large numbers
;we could divide the abs value of (square guess - x) by x itself
(define (sqrt x)
  (define (good-enough? guess)
    (< (/ (abs (- (square guess) x)) x) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))
