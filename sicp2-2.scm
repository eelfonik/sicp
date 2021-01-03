; Exercise 2.17
; get a list contains only the last element of a given (nonempty) list
; ref: length defined in the notes
(define (last-pair list)
  (if (= (length list) 1)
    list
    (last-pair (cdr list))
  )
)

; Exercise 2.18
; reverse a list
; N.B. `nil` doesn't work in MIT/GNU Scheme, we need to use `()` or `'()`
(define (reverse list)
  (define (reverse-iter items return-list)
    (if (null? items)
      return-list
      (reverse-iter (cdr items) (cons (car items) return-list))
    )
  )
  (reverse-iter list ())
)

; Exercise 2.19
; coin changes again
; find how many ways we have for changing a given amount with the coins available
(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))
(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))

; why we call it primitive instead of function ?
; why we cannot use `null?` directly ?
(define (no-more? list)
  (null? list)
)

(define (except-first-denomination list)
  (cdr list)
)

(define (first-denomination list)
  (car list)
)

; Exercise 2.20
; define procedures that can take arbitrary numbers of arguments
; by using *dotted-tail-notation*
; much like in the js array spreading operator ? 
; const a = [1,2,3,4]
; function bla([first, ...rest]) {}
(define (same-parity first . rest)
  (define (is-same-parity? a)
    (= (remainder first 2) (remainder a 2))
  )
  (define (parity-iter list acc)
    (if (null? list)
      acc
      (parity-iter (cdr list) 
        (if (is-same-parity? (car list))
          (cons (car list) acc)
          acc
        )
      )
    )
  )
  (cons first (reverse (parity-iter rest ())))
)

; Exercise 2.21 concerning mapping list
(define (square-list items)
  (if (null? items)
      ()
      (cons (* (car items) (car items)) (square-list (cdr items)))))

(define (square-list items)
  (map (lambda (x) (* x x)) items))

; Exercise 2.22
; make the map procedure iterative instead of recursive
; which ended have either a revered order results list
; or sth like `((2 3) . 1)`
; TODO how to make that work ??????

(define (map-1 procedure items)
  (define (map-iter procedure list acc)
    (if (null? list)
      acc
      (map-iter procedure (cdr list) (cons (procedure (car list)) acc))
    )
  )
  (map-iter procedure items ())
)

; Exercise 2.23
; for-each (that don't need to return any thing, but just apply it to each item)
(define (for-each proc items)
  ; here we add an eval that will apply the transform but always return true
  (define (for-each-iter items eval)
    (if (null? items)
      true
      (for-each-iter (cdr items) (proc (car items)))
    )
  )
  (for-each-iter items true)
)

; Exercise 2.24
; represent (list 1 (list 2 (list 3 4))) as sequence and tree
; see the diagram inside note


; Exercise 2.25
; 




