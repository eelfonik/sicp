; sigma notation
(define (sigma term next a b)
  (if (> a b)
    0
    (+ (term a) (sigma term next (next a) b)))
)

; Exercise 1.29
; Simpson's Rule to calculate the integral of a function f between a and b
; 计算积分。。。
(define (odd? n)
  (= (remainder n 2) 1)
)
(define (cube x)
  (* x x x))

(define (simpson-integral f a b n)
  (define h (/ (- b a) n))
  (define (term i)
    (cond ((or (= i 0) (= i n)) (f (+ a (* h i))))
      ((odd? i) (* 4 (f (+ a (* h i)))))
      (else (* 2 (f (+ a (* h i)))))
    )
  )
  (define (next i)
    (+ i 1))
  (if (odd? n)
    false
    (* (/ h 3) (sigma term next 0 n))
  ) 
)

; Exercise 1.30
; iterative process of sigma procedure
(define (sigma term next a b)
  (define (sigma-iter a result)
    (if (> a b)
      result
      (sigma-iter (next a) (+ result (term a)))))
  (sigma-iter a 0)
)

; Exercise 1.31
; iterative and recursive process of product
; which is similar to sigma but multiply the result of a function and a give range
; and use that procedure to rewrite factorial & approximations to pi
; recursive product
(define (product term next a b)
  (if (> a b)
    1
    (* (term a) (product term next (next a) b))))

; iterative product
(define (product term next a b)
  (define (product-iter a result)
    (if (> a b)
      result
      (product-iter (next a) (* result (term a)))))
  (product-iter a 1)
)

; the factorial can be represent as
(define (factorial n)
  (define (term x)
    x)
  (define (next x)
    (+ x 1))
  (product term next 1 n)
)

; and the approximations to pi can be represent as
(define (approx-pi n)
  (define (term x)
    (cond ((= x 1) (/ 2.0 3.0))
      ((even? x) (/ (+ x 2.0) (+ x 1.0)))
      (else (/ (+ x 1.0) (+ x 2.0)))
    )
  )
  (define (next x)
    (+ x 1))
  (* 4.0 (product term next 1 n))
)


; Exercise 1.32
; recursive higher-order procedure to represent sigma or product or any other operator
; 书里把这个procedure叫做 'accumulate'
(define (operate-range operator default-value term next a b)
  (if (> a b)
    default-value
    (operator (term a) (operate-range operator default-value term next (next a) b)))
)
; then product can be represent as
(define (product term next a b)
  (define (operator x y)
    (* x y))
  (operate-range operator 1 term next a b))
; and the sigma can be represent as
(define (sigma term next a b)
  (define (operator x y)
    (+ x y))
  (operate-range operator 0 term next a b))

(define (sum-square a b)
  (define (term x)
    (* x x))
  (define (next x)
    (+ 1 x))
  (sigma term next a b)
)

; iterative hight-order procedure
(define (operate-range operator default-value term next a b)
  (define (operate-range-iter a result)
    (if (> a b)
      result
      (operate-range-iter (next a) (operator result (term a))))
  )
  (operate-range-iter a default-value)
)

; Exercise 1.33
; further generalize the above procedure by introducing a filter
; that accumulate only the values between a range and satisfy the filter
(define (filtered-accumulate operator default-value term next a b filter)
  (if (> a b) default-value
    (if (filter a)
      (operator (term a) (filtered-accumulate operator default-value term next (next a) b filter))
      (filtered-accumulate operator default-value term next (next a) b filter))
  )
  ; or the iterative version
  ; (define (accu-filter-iter result a)
  ;   (if (> a b)
  ;     result
  ;     (accu-filter-iter ((if (filter a)
  ;       (operator result (term a))
  ;       result)) (next a)))
  ; )
  ; (accu-filter-iter default-value a)
)

; then 1.the sum of the squares of the prime numbers in the interval a to b
; assume there's already a prime? procedure from 1-2
(define (sum-prime-square a b)
  (define (operator x y)
    (+ x y))
  (define (term x)
    (* x x))
  (define (next x)
    (+ x 1))
  (filtered-accumulate operator 0 term next a b prime?)
)

; then 2.the product of all the positive integers less than n that are relatively prime to n
(define (gcd x y)
  (cond ((< x y) (gcd y x))
    ((= y 0) x)
    (else (gcd y (remainder x y)))
  )
)
(define (product-prime-to-n n)
  (define (operator x y)
    (* x y))
  (define (term x) x)
  (define (next x)
    (+ x 1))
  (define (filter x)
    (= (gcd x n) 1)
  )
  (filtered-accumulate operator 1 term next 1 n filter)
)

; Exercise 1.34
(define (f g)
  (g 2))
; so if we try to do (f f), as f is a procedure that accept another procedure as param
; the evaluation of (f 2) would result an error which said "object 2 cannot be appliable"
; because the interpreter will try to apply 2 as a *procedure* to 2


; Exercise 1.35
; gr (golden ratio) is defined as gr * gr = gr + 1
; and fixed point of a f(x) is defined as f(x) = x
; so find the gr is trying to find the fixed point of function f(x) = 1 + 1/x
(define (fixed-point f first-guess)
  (define (good-enough? a b)
    (< (abs (- a b)) 0.00001))
  (define (try guess)
    (let ((next (f guess)))
      (cond ((good-enough? guess next) next)
        (else (try next)))
    )
  )
  (try first-guess)
)

(define (average x y)
  (/ (+ x y) 2.0))
; then the golden ratio can be find as:
(fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0)
; or better we can use average damping
(fixed-point (lambda (x) (average (x (+ 1 (/ 1 x))))) 1.0)

; Exercise 1.36
; find a solution to x powder x = 1000 by finding a fixed point of x -> log(1000)/log(x)
(define (fixed-point f first-guess)
  (define (good-enough? a b)
    (< (abs (- a b)) 0.00001))
  (define (try guess)
    (display guess)
    (newline)
    (let ((next (f guess)))
      (cond ((good-enough? guess next) next)
        (else (try next)))
    )
  )
  (try first-guess)
)

(fixed-point (lambda (x) (/ (log 1000) (log x))) 2.0)
; output of this version:
; 2.
; 9.965784284662087
; 3.004472209841214
; 6.279195757507157
; 3.759850702401539
; 5.215843784925895
; 4.182207192401397
; 4.8277650983445906
; 4.387593384662677
; 4.671250085763899
; 4.481403616895052
; 4.6053657460929
; 4.5230849678718865
; 4.577114682047341
; 4.541382480151454
; 4.564903245230833
; 4.549372679303342
; 4.559606491913287
; 4.552853875788271
; 4.557305529748263
; 4.554369064436181
; 4.556305311532999
; 4.555028263573554
; 4.555870396702851
; 4.555315001192079
; 4.5556812635433275
; 4.555439715736846
; 4.555599009998291
; 4.555493957531389
; 4.555563237292884
; 4.555517548417651
; 4.555547679306398
; 4.555527808516254
; 4.555540912917957
;Value: 4.555532270803653

(fixed-point (lambda (x) (average x (/ (log 1000) (log x)))) 2.0)
; output of the average damping version:
; 2.
; 5.9828921423310435
; 4.922168721308343
; 4.628224318195455
; 4.568346513136242
; 4.5577305909237005
; 4.555909809045131
; 4.555599411610624
; 4.5555465521473675
;Value: 4.555537551999825

; Exercise 1.37
; k-term finite continued fraction
(define (cont-frac n d k)
  (define (iter i)
    (cond ((= i k) (/ (n i) (d i)))
      (else (/ (n i) (+ (d i) (iter (+ i 1))))))
  )
  (iter 1)
)

; iterative version
(define (cont-frac n d k)
  (define (iter i result)
    (cond ((= i 0) result)
      (else (iter (- i 1) (/ (n i) (+ (d i) result)))))
  )
  (iter k 0)
)

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           10)

; Exercise 1.38
; Euler's expansion using k-term finite continued fraction to approch e
; 1 1, 2 2 , 3 1, 4 1, 5 4, 6 1, 7 1, 8 6, 11 8
; (i-2)/3 remainder = 0 => i - (i - 2)/3 => 2/3(i + 1)
; else 1
(+ 2 (cont-frac
      (lambda (i) 1.0)
      (lambda (i)
        (if (= (remainder (- i 2) 3) 0)
            (/ (+ i 1) 1.5)
            1.0
        ))
      10))

; Exercise 1.39
; continued fraction representation of the tangent function
; note here x represents radian, so it's value is limited
(define (tan-cf x k)
  (let ((a (- (* x x))))
    (cont-frac (lambda (i) (if (= i 1) x a)) (lambda (i) (- (* i 2) 1)) k)
  ) 
)

; Exercise 1.40
; 求导公式
(define dx 0.00001)
(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))

(define (fixed-point-of-transform g transform guess)
  (fixed-point (transform g) guess))

(define (newtons-method g guess)
  (fixed-point-of-transform g newton-transform guess))

(define (sqrt x)
  (fixed-point-of-transform (lambda (y) (- (square y) x))
                            newton-transform
                            1.0))

(define (cubic a b c)
  (lambda (x) (+ (* x x x) (* a x x) (* b x) c)))

; Exercise 1.41
; Define a procedure double that takes a procedure of one argument as argument
; and returns a procedure that applies the original procedure twice. 
(define (double g)
  (display g)
  (newline)
  (lambda (x) (g (g x)))
)
(define (inc x)
  (+ x 1))

(((double (double double)) inc) 5)
; the above will first evaluated as following:
; 1. g is "double"
; (((double (lambda (x) (double (double x)))) inc) 5)

; ; 2. g is lambda (x) (double (double x))
; (((lambda (x) (double (double (double (double x))))) inc) 5)

; ; 3. substitue x by inc
; ((double (double (double (double inc)))) 5)

; ; 4. g is "inc"
; ((double (double (double (lambda (x) (inc (inc x)))))) 5)

; ; 5. g is lambda (x) (inc (inc x))
; ((double (double (lambda (x) (inc (inc (inc (inc x))))))) 5)

; ; 6. g is lambda (x) (inc (inc (inc (inc x))))
; ((double (lambda (x) (inc (inc (inc (inc (inc (inc (inc (inc x)))))))))) 5)

; ; 7. g is lambda (x) (inc (inc (inc (inc (inc (inc (inc (inc x)))))))) 
; ((lambda (x) (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc x))))))))))))))))) 5)

; ; 8. substitute x by 5
; (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc 5))))))))))))))))
; which means apply the procedure "inc" 16 times on previous results

; Exercise 1.42
; Procedure composition
(define (compose f g)
  (lambda (x) (f (g x)))
)
((compose square inc) 6)

; Exercise 1.43
; repeat a funtion n times
(define (repeat f n)
  (define (iter i x)
    (if (= i n)
      (f x)
      (f (iter (+ i 1) x)))
  )
  (lambda (x) (iter 1 x))
)

; or use the compose above
(define (repeat f n)
  (define (iter i func)
    (if (= i 1)
      func
      (iter (- i 1) (compose f func)))
  )
  (iter n f)
)

((repeat square 2) 5)

; Exercise 1.44
; If f is a function and dx is some small number
; then the smoothed version of f is the function whose value at a point x is the average of f(x - dx), f(x), and f(x + dx)
(define (smooth f)
  (let ((dx 0.00001))
    (lambda (x) (/ (+ (f x) (f (- x dx)) (f (+ x dx))) 3))
  )
)
; n-fold smooth
(define (n-fold-smooth repeat smooth f n)
  ((repeat smooth n) f))


; Exercise 1.45
; where apply average-dump only once is not enough to converge....
; compute nth roots as a fixed-point search
; based upon repeated average damping of y->x/y[n-1]

(define (nth x n)
  (define (iter i result)
    (if (= i 0)
      result
      (iter (- i 1) (* result x)))
  )
  (iter n 1)
)

(define (average-damp f)
  (lambda (x) (average x (f x))))

; actually I don't know where this log2 came from...
; but it turns out enough to get the number of average-damp needed for nth roots
(define (log2 x) (/ (log x) (log 2)))
(define (nth-root n x)
  (fixed-point ((repeat average-damp (floor (log2 n))) (lambda (y) (/ x (nth y (- n 1))))) 1.0)
)

; Exercise 1.46
; iterative improvement
(define (iter-improv good-enough? improv)
  (define (iter guess)
    (if (good-enough? guess)
      guess
      (iter (improv guess))))
  (lambda (guess) (iter guess))
)

; then the fixed-point can be expressed as:
(define (fixed-point f first-guess)
  (define (good-enough? guess)
    (< (abs (- guess (f guess))) 0.00001))
  ((iter-improv good-enough? f) first-guess)
)

; and the sqrt can be expressed as
(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  ((iter-improv good-enough? improve) 1.0)
)
