(define (domain cleaning_rooms_with_keys_and_pickup)
  (:requirements :strips :typing :action-costs)

  (:types
   room - object
   robot - object
   quantity - object
   key - object
   sweeper - object
   mop - object
   )

  (:predicates
   (at-robot ?r - robot ?loc - room)
   (at-key ?k - key ?loc - room)
   (at-mop ?m - mop ?loc - room)
   (at-sweeper ?s - sweeper ?loc - room)
   (has-key ?r - robot ?k - key)
   (has-dust ?room - room)
   (has-stains ?room - room)
   (has-sweeper ?r - robot ?s - sweeper)
   (has-mop ?r - robot ?m - mop)
   (dirty ?room - room)
   (to-be-cleaned ?room - room ?q - quantity)
   (locked ?room - room)
   (key-opens ?k - key ?lock - room)
   (plus1 ?q1 ?q2 - quantity)
   )

  (:functions
   (distance ?l1 ?l2 - room)
   (total-cost)
   (cost-of ?q - quantity)
   )

  (:action sweep
   :parameters (?r - robot ?room - room ?q - quantity ?s - sweeper)
   :precondition (and (at-robot ?r ?room) (dirty ?room) (has-dust ?room) (to-be-cleaned ?room ?q) (has-sweeper ?r ?s))
   :effect (and (when (not (has-stains ?room))
                    (and (not (dirty ?room)) (not (to-be-cleaned ?room ?q)))) 
                (not (has-dust ?room))
                (increase (total-cost) (cost-of ?q)))
   )
   
   (:action clean-mop
   :parameters (?r - robot ?room - room ?q - quantity ?m - mop)
   :precondition (and (at-robot ?r ?room) (dirty ?room) (has-stains ?room) (to-be-cleaned ?room ?q) (has-mop ?r ?m))
   :effect (and (when (not (has-dust ?room))
                    (and (not (dirty ?room)) (not (to-be-cleaned ?room ?q)))) 
                (not (has-stains ?room))
                (increase (total-cost) (cost-of ?q)))
   )

  (:action move
   :parameters (?r - robot ?from ?to - room)
   :precondition (and (at-robot ?r ?from) (not (locked ?to)))
   :effect (and (not (at-robot ?r ?from))
                (at-robot ?r ?to)
                (increase (total-cost) (distance ?from ?to)))
   )

  (:action unlock
   :parameters (?r - robot ?room - room ?k - key)
   :precondition (and (locked ?room) (has-key ?r ?k) (key-opens ?k ?room))
   :effect (and (not (locked ?room))
   	   	 (increase (total-cost) 1))
   )

  (:action pick-up-key
   :parameters (?r - robot ?room - room ?key - key)
   :precondition (and (at-robot ?r ?room) (at-key ?key ?room))
   :effect (and (not (at-key ?key ?room)) (has-key ?r ?key)
   	   	 (increase (total-cost) 1))
   )
   
  (:action pick-up-mop
   :parameters (?r - robot ?room - room ?mop - mop)
   :precondition (and (at-robot ?r ?room) (at-mop ?mop ?room))
   :effect (and (not (at-mop ?mop ?room)) (has-mop ?r ?mop)
   	   	 (increase (total-cost) 1))
   )
   
  (:action pick-up-sweeper
   :parameters (?r - robot ?room - room ?sweeper - sweeper)
   :precondition (and (at-robot ?r ?room) (at-sweeper ?sweeper ?room))
   :effect (and (not (at-sweeper ?sweeper ?room)) (has-sweeper ?r ?sweeper)
   	   	 (increase (total-cost) 1))
   )
)
