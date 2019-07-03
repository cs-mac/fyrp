;; Copyright 2019 Chi Sam Mac
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;     http://www.apache.org/licenses/LICENSE-2.0
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;;; ACT-R Model of the task [depressed]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; [BASIC INFORMATION] ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Creator:                      Chi Sam Mac (s2588382)
; Course:                       First-year Research Project [KIM.FYRP11.2018-2019.2]
; Supervised by:                M.K. van Vugt
; ACT-R version:                7.13
; More information:             https://bitbucket.org/csmac/fyrp
; Contact:                      c.s.mac@student.rug.nl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(clear-all)

(define-model freerecall

(sgp 
   :rt -1 ; retrieval threshold
   :v nil ; enable/disable trace
   :trace-detail low ; set level of trace detail
   :act nil ;t/medium/low/nil ;;tracing activation values
   :show-focus t ; show location of visual focus
   :er t ; Makes it so ties in productions are determined randomly (nil = fixed order)
   :bll .5 ; Set base-level learning, more frequently/recently retrieved items gain higher activation
   :esc t ; use subsymbolic processing
   :auto-attend t ; visual location requests are automatically accompanied by a request to move attention to the location found
   :declarative-num-finsts 21 ; number of items that are kept as recently retrieved 
   :declarative-finst-span 21 ; how long items stay in the recently-retrieved state 
   :ans 0.1 ; activation noise 
   :mas 8 ; maximum associative strength, uses S value in Sji calculation 
   :egs 0.1 ; noise in utility computation
   :ol nil ; use base-level equation that requires complete history of a chunk (instead of formula that uses an approximation)
   :model-warnings nil 
)
  
(chunk-type study-words state first valence1 second valence2 third valence3 fourth valence4 position)
(chunk-type memory word valence)
(chunk-type goal state)
(chunk-type recall state position)
(chunk-type subgoal1 state target targetval)

(add-dm 
   (start isa chunk) 
   (attend isa chunk)
   (beginclear isa chunk)
   (beginrecall isa chunk)
   (respond isa chunk) 
   (done isa chunk)
   (retrieve isa chunk)
   (harvest isa chunk)
   (rehearse isa chunk)
   (memorize isa chunk)
   (first isa chunk)
   (second isa chunk)
   (third isa chunk)
   (fourth isa chunk)
   (valence1 isa chunk)
   (valence2 isa chunk)
   (valence3 isa chunk)
   (valence4 isa chunk)   
   (subgoal1 isa chunk)
   (goal isa study-words state start)
   (startrecall isa recall state beginrecall)   
)

(P find-unattended-word
   =goal>
      isa         study-words
      state       start
 ==>
   +visual-location>
      :attended    nil
   =goal>
      state       find-location
)

(P attend-word
   =goal>
      isa         study-words
      state       find-location
   =visual-location>
   ?visual>
      state       free
==>
#|    +visual>
      cmd         move-attention
      screen-pos  =visual-location |#
   =goal>
      state       attend
)

(P high-first
   =goal>
      isa         study-words
      state       attend
      first       nil
   =visual>
      value       =word
      color       =col
   ?imaginal>
      state       free
==>
   =goal>
      state       memorize
      first       =word
      position    first     
      valence1    =col 
   +imaginal>
      isa         memory
      word        =word   
      valence     =col
)

(P high-second
   =goal>
      isa         study-words
      state       attend
      second      nil
   =visual>
      value       =word
      color       =col      
   ?imaginal>
      state       free
==>
   =goal>
      state       memorize
      second      =word
      position    first
      valence2    =col
   +imaginal>
      isa         memory
      word        =word
      valence     =col      
)

(P high-third
   =goal>
      isa         study-words
      state       attend
      third       nil
   =visual>
      value       =word
      color       =col       
   ?imaginal>
      state       free
==>
   =goal>
      state       memorize
      third       =word
      position    first
      valence3    =col
   +imaginal>
      isa         memory
      word        =word
      valence     =col
)

(P high-fourth
   =goal>
      isa         study-words
      state       attend
      fourth      nil
   =visual>
      value       =word
      color       =col       
   ?imaginal>
      state       free
==>
   =goal>
      state       memorize
      fourth      =word
      position    first
      valence4    =col
   +imaginal>
      isa         memory
      word        =word
      valence     =col
)

(P attend-first
   =goal>
      isa         study-words
      state       attend
      - first     nil
      - second    nil
      - third     nil
      - fourth    nil
   =visual>
      value       =word
      color       =col        
   ?imaginal>
      state       free
==>
   =goal>
      state       memorize
      first       =word
      position    first
      valence1    =col
   +imaginal>
      isa         memory
      word        =word
      valence     =col
)

(P attend-second
   =goal>
      isa         study-words
      state       attend
      - first     nil
      - second    nil
      - third     nil
      - fourth    nil
   =visual>
      value       =word
      color       =col        
   ?imaginal>
      state       free
==>
   =goal>
      state       memorize
      second      =word
      position    first
      valence2    =col
   +imaginal>
      isa         memory
      word        =word
      valence     =col
)

(P attend-third
   =goal>
      isa         study-words
      state       attend
      - first     nil
      - second    nil
      - third     nil
      - fourth    nil
   =visual>
      value       =word
      color       =col        
   ?imaginal>
      state       free
==>
   =goal>
      state       memorize
      third       =word
      position    first
      valence3    =col
   +imaginal>
      isa         memory
      word        =word
      valence     =col
)

(P attend-fourth
   =goal>
      isa         study-words
      state       attend
      - first     nil
      - second    nil
      - third     nil
      - fourth    nil
   =visual>
      value       =word
      color       =col        
   ?imaginal>
      state       free
==>
   =goal>
      state       memorize
      fourth      =word
      position    first
      valence4    =col
   +imaginal>
      isa         memory
      word        =word
      valence     =col
)

(P add-to-memory-1
   =goal>
      isa         study-words
      state       memorize
      first       =word
      position    first
   =imaginal>
      isa         memory
      word        =word
==>
   =goal>
      isa         study-words
      state       rehearse
      first       =word
      position    first  
)

(P add-to-memory-2
   =goal>
      isa         study-words
      state       memorize
      second      =word
      position    first
   =imaginal>
      isa         memory
      word        =word
==>
   =goal>
      isa         study-words
      state       rehearse
      second      =word
      position    first  
)

(P add-to-memory-3
   =goal>
      isa         study-words
      state       memorize
      third      =word
      position    first
   =imaginal>
      isa         memory
      word        =word
==>
   =goal>
      isa         study-words
      state       rehearse
      third      =word
      position    first  
)

(P add-to-memory-4
   =goal>
      isa         study-words
      state       memorize
      fourth      =word
      position    first
   =imaginal>
      isa         memory
      word        =word
==>
   =goal>
      isa         study-words
      state       rehearse
      fourth      =word
      position    first  
)

(P rehearse-first
   =goal>
      isa         study-words
      state       rehearse
      first       =word
      valence1    =val
      position    first
==>
   =goal>
      state       subgoal1
      target      =word
      position    second
   +retrieval>
      isa         memory
      word        =word  
      valence     =val    
)

(P rehearse-second
   =goal>
      isa         study-words
      state       rehearse
      second      =word
      valence2    =val      
      position    second
==>
   =goal>
      state        subgoal1
      target      =word
      position    third
   +retrieval>
      isa         memory   
      word        =word   
      valence     =val     
)

(P rehearse-third
   =goal>
      isa         study-words
      state       rehearse
      third       =word 
      valence3    =val      
      position    third
==>
   =goal>
      state       subgoal1
      target      =word
      position    fourth
   +retrieval>
      isa         memory   
      word        =word  
      valence     =val
)

(P rehearse-fourth
   =goal>
      isa         study-words
      state       rehearse
      fourth      =word
      valence4    =val        
      position    fourth
==>
   =goal>
      state       subgoal1
      target      =word
      position    first
   +retrieval>
      isa         memory   
      word        =word  
      valence     =val
)

(p rehearse-it 
   =goal>
      state       subgoal1
      target      =word
      position    =pos
   =retrieval>
      word        =word
      valence     =val
   ?imaginal>
      state       free     
==>
   =goal>
      isa         study-words
      state       rehearse
      position    =pos
   +imaginal>
      isa         memory
      word        =word   
      valence     =val   
   !eval! ("rehearsed-word" =word)            
)

(p skip-rehearse 
   =goal>
      state     subgoal1
      target      =word
      position    =pos
   =retrieval>
      isa         memory
      word        =word
   ?imaginal>
      state       free
==>
   =goal>
      isa         study-words
      state       rehearse
      position    =pos     
)

(p else_new
   =goal>
      isa         study-words
      state       rehearse
   =visual-location>
   ?visual>
      state       free  
==>
#|    +visual>
      cmd         move-attention
      screen-pos  =visual-location |#
   =goal>
      state       attend  
)

(p skip-first
   =goal>
      isa         study-words
      state       rehearse
      first       nil
      position    first 
==>
   =goal>
      isa         study-words
      state       rehearse
      position    second
)

(p skip-second
   =goal>
      isa         study-words
      state       rehearse
      second      nil
      position    second        
==>
   =goal>
      isa         study-words
      state       rehearse
      position    third
)

(p skip-third
   =goal>
      isa         study-words
      state       rehearse
      third       nil
      position    third        
==>
   =goal>
      isa         study-words
      state       rehearse
      position    fourth
)

(p skip-fourth
   =goal>
      isa         study-words
      state       rehearse
      fourth      nil
      position    fourth          
==>
   =goal>
      isa         study-words
      state       rehearse
      position    first
)

(p choose-normal-recall
   =goal>
      isa         recall
      state       beginrecall
==>
      =goal>
      isa         recall
      state       choose      
)

(p choose-negative-recall
   =goal>
      isa         recall
      state       beginrecall
==>
      =goal>
      isa         recall
      state       beginrecall-negative      
)

(p start-recall-end
   =goal>
      isa         recall
      state       beginrecall-negative         
==>
   =goal>
      isa         recall
      state       harvest-neg
   +retrieval>
      isa         study-words
    - first       nil
    - second      nil
    - third       nil
    - fourth      nil
) 

(p harvest-one-neg
   =goal>
      isa         recall
      state       harvest-neg     
   =retrieval>
      isa         study-words 
      first       =word
      valence1    RED    
==>
   +retrieval>
      isa         study-words 
      first       =word
      valence1    RED  
   +imaginal>
      valence     RED       
   =goal>
      isa         recall
      state       retrieve1 
)

(p harvest-two-neg
   =goal>
      isa         recall
      state       harvest-neg
   =retrieval>
      isa         study-words 
      first       =word
      valence2    RED    
==>
   +retrieval>
      isa         study-words 
      first       =word
      valence2    RED  
   +imaginal>
      valence     RED       
   =goal>
      isa         recall
      state       retrieve2 
)

(p harvest-three-neg
   =goal>
      isa         recall
      state       harvest-neg    
   =retrieval>
      isa         study-words 
      first       =word
      valence3    RED    
==>
   +retrieval>
      isa         study-words 
      first       =word
      valence3    RED  
   +imaginal>
      valence     RED       
   =goal>
      isa         recall
      state       retrieve3 
)

(p harvest-four-neg
   =goal>
      isa         recall
      state       harvest-neg   
   =retrieval>
      isa         study-words 
      first       =word
      valence4    RED    
==>
   +retrieval>
      isa         study-words 
      first       =word
      valence4    RED  
   +imaginal>
      valence     RED       
   =goal>
      isa         recall
      state       retrieve4 
)

(p retrieve-one-neg
   =goal>
      isa         recall
      state       retrieve1    
   =retrieval>
      isa         study-words 
      first       =word
      valence1    RED  
==>
   =goal>
      isa         recall
      state       beginrecall-normal  
   !eval! ("retrieved-word" =word)
)

(p retrieve-two-neg
   =goal>
      isa         recall
      state       retrieve2 
   =retrieval>
      isa         study-words 
      second      =word
      valence2    RED  
==>
   =goal>
      isa         recall
      state       beginrecall-normal   
   !eval! ("retrieved-word" =word)
)

(p retrieve-three-neg
   =goal>
      isa         recall
      state       retrieve3
   =retrieval>
      isa         study-words 
      third       =word
      valence3    RED  
==>
   =goal>
      isa         recall
      state       beginrecall-normal   
   !eval! ("retrieved-word" =word)
)

(p retrieve-four-neg
   =goal>
      isa         recall
      state       retrieve4
   =retrieval>
      isa         study-words 
      fourth      =word
      valence4    RED  
==>
   =goal>
      isa         recall
      state       beginrecall-normal   
   !eval! ("retrieved-word" =word)
)

(p choose-first
   =goal>    
      isa         recall
      state       choose 
==>
   =goal>    
      isa         recall
      state       retrieve
      position    first
)

(p choose-second
   =goal>    
      isa         recall
      state       choose 
==>
   =goal>    
      isa         recall
      state       retrieve
      position    second
)

(p choose-third
   =goal>    
      isa         recall
      state       choose 
==>
   =goal>    
      isa         recall
      state       retrieve
      position    third
)

(p choose-fourth
   =goal>    
      isa         recall
      state       choose 
==>
   =goal>    
      isa         recall
      state       retrieve
      position    fourth
)

(p retrieve-first
   =goal>
      isa         recall
      state       retrieve
      position    first
   ?retrieval>
      buffer      empty
      state       free 
==>
   =goal>
      isa         recall
      state       harvest 
      position    first
   +retrieval>
      isa         study-words
    - first       nil
    - valence1    nil
)

(p retrieve-second
   =goal>
      isa         recall
      state       retrieve
      position    second
   ?retrieval>
      buffer      empty
      state       free 
==>
   =goal>
      isa         recall
      state       harvest   
      position    second
   +retrieval>
      isa         study-words
    - second      nil
    - valence2    nil    
)

(p retrieve-third
   =goal>
      isa         recall
      state       retrieve
      position    third
   ?retrieval>
      buffer      empty
      state       free 
==>
   =goal>
      isa         recall
      state       harvest
      position    third   
   +retrieval>
      isa         study-words
    - third       nil
    - valence3    nil    
)

(p retrieve-fourth
   =goal>
      isa         recall
      state       retrieve
      position    fourth
   ?retrieval>
      buffer      empty
      state       free 
==>
   =goal>
      isa         recall
      state       harvest   
      position    fourth
   +retrieval>
      isa         study-words
    - fourth      nil
    - valence4    nil    
)

(p harvest-first
   =goal>
      isa         recall
      state       harvest 
      position    first     
   =retrieval>
      isa         study-words 
      first       =word
      valence1    =valence
==>
   =goal>
      isa         recall
      state       retrieve
      position    second
   !eval! ("retrieved-word" =word)
)

(p harvest-second
   =goal>
      isa         recall
      state       harvest   
      position    second   
   =retrieval>
      isa         study-words 
      second      =word
      valence2    =valence      
==>
   =goal>
      isa         recall
      state       retrieve
      position    third
   !eval! ("retrieved-word" =word)
)

(p harvest-third
   =goal>
      isa         recall
      state       harvest   
      position    third   
   =retrieval>
      isa         study-words 
      third       =word
      valence3    =valence      
==>
   =goal>
      isa         recall
      state       retrieve
      position    fourth
   !eval! ("retrieved-word" =word)
)

(p harvest-fourth
   =goal>
      isa         recall
      state       harvest    
      position    fourth  
   =retrieval>
      isa         study-words 
      fourth      =word
      valence4    =valence      
==>
   =goal>
      isa         recall
      state       beginrecall-normal  
   !eval! ("retrieved-word" =word)
)

(p start-recall-normal
   =goal>
      isa         recall
      state       beginrecall-normal     
==>
   =goal>
      isa         recall
      state       harvest-normal      
   +retrieval>
      isa         memory
    - word        nil
    - valence     nil
      :recently-retrieved nil ; only get items that were not recently retrieved
) 

(p harvest
   =goal>
      isa         recall
      state       harvest-normal      
   =retrieval>
      isa         memory 
      word        =word
      valence     =val    
==>
   +retrieval>
      isa         memory 
      word        =word
      valence     =val
   +imaginal>
      valence     =val      
   =goal>
      isa         recall
      state       retrieve  
)

(p retrieve
   =goal>
      isa         recall
      state       retrieve      
   =retrieval>
      isa         memory 
      word        =word
      valence     =val  
==>
   =goal>
      isa         recall
      state       beginrecall-normal 
   !eval! ("retrieved-word" =word)
)

(goal-focus goal)

; :u ;; utility of prodiction
; :at ;; action time of production 

(spp skip-rehearse :u .5) 
(spp high-first :at 2)
(spp high-second :at 2)
(spp high-third :at 0.5)
(spp high-fourth :at 0.5)
(spp rehearse-it :u 5 :at .3) 
(spp else_new :u 10) ; ensure new words are always attended
(spp retrieve :u 2)
(spp start-recall :u 1)
(spp choose-normal-recall :u 0.25)
(spp choose-negative-recall :u 0.26)
(spp choose-first :u .21)
(spp choose-second :u .22)
(spp choose-third :u .23)
(spp choose-fourth :u .24)
)