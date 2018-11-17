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
; pairs of non-negative integers
(define (expo x n)
  (define (expo-iter x n res)
    (if (= n 0)
      res
      (expo-iter x (- n 1) (* res x)))
  )
  (expo-iter x n 1)
)
(define (largest-pow-of x res)
  (define (pow-iter x res pow)
    (if (= 0 (remainder res x))
      (pow-iter x (/ res x) (+ pow 1))
      pow
    )
  )
  (pow-iter x res 0)
)
(define (int-cons a b)
  (* (expo 2 a) (expo 3 b))
)
(define (int-car z)
  (largest-pow-of 2 z)
)
(define (int-cdr z)
  (largest-pow-of 3 z)
)

; Exercise 2.6
; Church numerals
(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x))))
)
; if we evaluate (add-1 zero)
; (lambda (f) (lambda (x) (f ((lambda (x) x) x))))
; (lambda (f) (lambda (x) (f x)))

; It means that a number N can be represented
; as applying f to the inner most x N times
(define one (lambda (f) (lambda (x) (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))

; then the add a b should be
; apply the f a times to the "value" that obtained by 
; applying the f b times to the inner most x
(define (church-add a b)
  (lambda (f) (lambda (x) ((a f) ((b f) x)))))

; Exercise 2.7
; interval constructor & selectors
; an abstract object that has two endpoints: a lower bound and an upper bound

(define (make-interval a b)
  (cons a b))

(define (upper-bound z)
  (max (car z) (cdr z)))
(define (lower-bound z)
  (min (cdr z) (car z)))

; Exercise 2.8
; sub-interval
(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
                  (- (upper-bound x) (lower-bound y)))
)
; or using the existing add-interval, defined as following:
(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y)) (+ (upper-bound x) (upper-bound y)))
)
; then the sub-interval can be represented as:
(define (sub-interval x y)
  (add-interval x (make-interval (- (lower-bound y)) (- (upper-bound y))))
)

; Exercise 2.9
; width of interval shows the uncertainty of number specified by the interval
; prove that for add/substract, the width of the combination is a function only related with the width of its intervals
; whereas it's not the case for multiply/division
(define (width-interval z)
  (/ (- (upper-bound z) (lower-bound z)) 2)
)
; assume for add-interval
; (as we showed above, the sub-interval is just another form of add-interval, so same for sub-interval)
; replace z by (add-interval x y)
(/ (- (upper-bound (add-interval x y)) (lower-bound (add-interval x y))) 2)
; apply the def of add-interval
(/ (- (upper-bound (make-interval (+ (lower-bound x) (lower-bound y)) (+ (upper-bound x) (upper-bound y)))) (lower-bound (make-interval (+ (lower-bound x) (lower-bound y)) (+ (upper-bound x) (upper-bound y))))) 2)
; apply the upper-bound & lower-bound def:
(/ (- (+ (upper-bound x) (upper-bound y)) (+ (lower-bound x) (lower-bound y))) 2)
; which can be transformed as:
(+ (/ (- (upper-bound x) (lower-bound x)) 2) (/ (- (upper-bound y) (lower-bound y)) 2))
; which is equal to:
(+ (width-interval x) (width-interval y))

; But for multiply/division
(/ (- (upper-bound (mul-interval x y)) (lower-bound (mul-interval x y))) 2)
; p1 = lower X * lower Y, p2 = lower X * upper Y, p3 = upper X * lower Y, p4 = upperX * upper Y
(/ (- (upper-bound (make-interval (min p1 p2 p3 p4) (max p1 p2 p3 p4))) (lower-bound (make-interval (min p1 p2 p3 p4) (max p1 p2 p3 p4)))) 2)
(/ (- (max p1 p2 p3 p4) (min p1 p2 p3 p4)) 2)
; which is not linear to (width-interval x) or (width-interval y)

; Exercise 2.10
; define multiply & division of intervals
; handle division with span zero
; N.b. a span zero means the lower-bound is less or equal to 0, and the upper-bound is more or equal to 0
; then the range of interval "spans" or "crossed" the value 0
(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (let ((upper (upper-bound y))
        (lower (lower-bound y)))
    ((if (and (>= (upper-bound y) 0)
              (<= (lower-bound y) 0))
          #f
          (mul-interval x 
            (make-interval (/ 1.0 upper)
                        (/ 1.0 lower)))))))





