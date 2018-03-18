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
(define (operate-range operator default-value term next a b)
  (if (> a b)
    default-value
    (operator (term a) (operate-range operator term next (next a) b)))
)
; then product can be represent as
(define (product term next a b)
  (define (operator x)
    (* x x))
  (operate-range operator 1 term next a b))
; and the sigma can be represent as
(define (sigma term next a b)
  (define (operator x)
    (+ x x))
  (operate-range operator 0 term next a b))

; iterative hight-order procedure
(define (operate-range operator default-value term next a b)
  (define (operate-range-iter a result)
    (if (> a b)
      result
      (operate-range-iter (next a) (operator result (term a))))
  )
  (operate-range-iter a default-value)
)
