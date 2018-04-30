; Exercise 2.1
; better make rational number that handles negative number
(define (gcd x y)
  (cond ((< x y) (gcd y x))
    ((= y 0) x)
    ((< y 0) (gcd x (- 0 y)))
    (else (gcd y (remainder x y)))
  )
)

(define (make-rat x y)
  (let ((g ((if (< y 0)
    -
    +) (gcd x y))))
    (cons (/ x g) (/ y g))
  )
)

; Exercise 2.2
; the line segment
(define (make-segment a b)
  (cons a b))

(define (start-point s)
  (car s))
(define (end-point s)
  (cdr s))

(define (make-point x y)
  (cons x y))
(define (x-point p)
  (car p))
(define (y-point p)
  (cdr p))

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (midpoint-segment segment)
  (
    let (
      (start (start-point segment))
      (end (end-point segment))
    )
    (make-point (/ (+ (x-point start) (x-point end)) 2) (/ (+ (y-point start) (y-point end)) 2))
  )
)

(define (create-segment x1 y1 x2 y2)
  (
    let (
      (start (make-point x1 y1))
      (end (make-point x2 y2))
    )
    (make-segment start end)
  )
)

(print-point (midpoint-segment (create-segment 2 8 10 7)))

; Exercise 2.3
; rectangle
(define (make-rect w h)
  (cons w h)
)
(define (getW rect)
  (car rect))
(define (getH rect)
  (cdr rect))

(define (len segment)
  (
    let (
      (start (start-point segment))
      (end (end-point segment))
      (sqr (lambda (x) (* x x)))
    )
    (sqrt (+ (sqr (- (x-point start) (x-point end))) (sqr (- (y-point start) (y-point end)))))
  )
)

(define (perimeter rect)
  (* 2 (+ (len (getH rect)) (len (getW rect))))
)
(define (area rect)
  (* (len (getH rect)) (len (getW rect)))
)

(define (create-rect x1 y1 x2 y2 x3 y3)
  ; this represent 3 consecutive points of a rectangle
  ; it worth checking if the 2 segments formed by these 3 points are perpendicular to each other
  ; but how? 
  (
    let (
      (w (create-segment x1 y1 x2 y2))
      (h (create-segment x2 y2 x3 y3))
    )
    (make-rect w h)
  )
)

; Amazing example to explain the "data"
; by demonstrate how we can define a data type
; using only procedures
(define (cons x y)
  (define (dispatch m)
    (cond ((= m 0) x)
      ((= m 1) y)
      (else (error "aguments is neither 0 or 1---CONS" m))
    )
  )
  ; note here we return a procedure in constructor
  dispatch
)

(define (car z)
  (z 0))

(define (cdr z)
  (z 1))

; Exercise 2.4
; Another implementation of cons/car/cdr
(define (cons x y)
  ;N.B. this lambda takes a procedure as argument
  (lambda (m) (m x y))
)

(define (car z)
  (z (lambda (p q) p))
)

(define (cdr z)
  (z (lambda (p q) q))
)

; Exercise 2.5
; pairs of nonnegative integers
(define (integer a b)
 ()
)





