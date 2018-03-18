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