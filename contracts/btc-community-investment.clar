;; Enhanced Community Micro-Investment Contract
;; With comprehensive data validation

;; Constants
(define-constant contract-owner tx-sender)
(define-constant min-investment u1000000) ;; 1 STX minimum investment
(define-constant max-investment u1000000000) ;; 1000 STX maximum investment
(define-constant voting-period u144) ;; ~1 day in blocks
(define-constant min-vote-threshold u500000) ;; Minimum votes needed
(define-constant min-title-length u4)
(define-constant max-title-length u50)
(define-constant min-description-length u10)
(define-constant max-description-length u500)

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u401))
(define-constant ERR-INVALID-AMOUNT (err u402))
(define-constant ERR-PROJECT-NOT-FOUND (err u404))
(define-constant ERR-PROJECT-EXPIRED (err u405))
(define-constant ERR-ALREADY-VOTED (err u406))
(define-constant ERR-INVALID-TITLE (err u407))
(define-constant ERR-INVALID-DESCRIPTION (err u408))
(define-constant ERR-INVALID-PROJECT-ID (err u409))
(define-constant ERR-MAX-INVESTMENT-EXCEEDED (err u410))
(define-constant ERR-ZERO-AMOUNT (err u411))
(define-constant ERR-PROJECT-INACTIVE (err u412))
(define-constant ERR-DUPLICATE-TITLE (err u413))

;; Data Variables
(define-data-var project-counter uint u0)

;; Data Maps
(define-map projects 
    { project-id: uint }
    {
        creator: principal,
        title: (string-ascii 50),
        description: (string-ascii 500),
        funding-goal: uint,
        current-amount: uint,
        status: (string-ascii 20),
        end-block: uint,
        creation-block: uint,
        last-updated: uint
    }
)

(define-map project-titles
    { title: (string-ascii 50) }
    { exists: bool }
)

(define-map investments
    { project-id: uint, investor: principal }
    {
        amount: uint,
        timestamp: uint,
        last-updated: uint
    }
)

(define-map votes
    { project-id: uint, voter: principal }
    {
        vote: bool,
        timestamp: uint
    }
)

(define-map vote-counts
    { project-id: uint }
    {
        total-votes: uint,
        positive-votes: uint,
        negative-votes: uint,
        last-updated: uint
    }
)

;; Private Helper Functions

;; Validate title
(define-private (is-valid-title (title (string-ascii 50)))
    (let ((title-length (len title)))
        (and 
            (>= title-length min-title-length)
            (<= title-length max-title-length)
            (not (is-eq title ""))
            (is-none (map-get? project-titles { title: title })))))

;; Validate description
(define-private (is-valid-description (description (string-ascii 500)))
    (let ((desc-length (len description)))
        (and 
            (>= desc-length min-description-length)
            (<= desc-length max-description-length)
            (not (is-eq description "")))))
