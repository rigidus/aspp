;; [[file:doc.org::*Сущности][entity_and_automates]]
;;;; Copyright © 2014-2015 Glukhov Mikhail. All rights reserved.
;;;; Licensed under the GNU AGPLv3
(in-package #:asp)

(define-automat checkpoint "Автомат стойки"
  ((id serial)
   (name varchar))
  (:fin :goon :payment :init :finding :dialog :standby :softlock :hardlock :selftest :poweron)
  ((:poweron :selftest :poweron-to-selftest)
   (:selftest :hardlock :selftest-to-hardlock)
   (:selftest :softlock :selftest-to-softlock)
   (:selftest :standby :selftest-to-standby)
   (:selftest :dialog :selftest-to-dialog)
   (:hardlock :selftest :hardlock-to-selftest)
   (:softlock :selftest :softlock-to-selftest)
   (:standby :selftest :standby-to-selftest)
   (:standby :finding :standby-to-finding)
   (:finding :selftest :finding-to-selftest)
   (:finding :dialog :finding-to-dialog)
   (:dialog :selftest :dialog-to-selftest)
   (:dialog :init :dialog-to-init)
   (:dialog :payment :dialog-to-payment)
   (:payment :selftest :payment-to-selftest)
   (:payment :init :payment-to-init)
   (:payment :dialog :payment-to-dialog)
   (:init :selftest :init-to-selftest)
   (:init :goon :init-to-goon)
   (:goon :selftest :goon-to-selftest)
   (:goon :fin :goon-to-fin)
   (:fin :selftest :fin-to-selftest)
   (:fin :standby :fin-to-standby)
   (:fin :dialog :fin-to-dialog)))


(defun power-on ()
  "selftest -> poweron")
;; entity_and_automates ends here
;; [[file:doc.org::*События][event_entity]]
(define-entity event "Сущность события"
  ((id serial)
   (name (or db-null varchar))
   (tag (or db-null varchar))
   (msg (or db-null varchar))
   (author-id (or db-null varchar))
   (ts-create bigint)))

(make-event-table)
;; event_entity ends here
;; [[file:doc.org::*Роли (role)][role_entity]]
(in-package #:asp)
(define-entity role "Сущность роли"
  ((id serial)
   (name varchar)
   (descr (or db-null varchar))))

(make-role-table)

;; (make-role :name "webuser")
;; (make-role :name "timebot")
;; (make-role :name "autotester")
;; (make-role :name "system")

;; (upd-role (get-role 1) (list :descr "Пользователи сайта. Они могут выполнять все пользовательские сценарии, (начиная с \"регистрации\" и \"логина\") и использовать все функциональные элементы на страницах сайта. Некоторые из пользователей, имеющих эту роль имеют дополнительные права, например на редактирование групп"))

;; (upd-role (get-role 2) (list :descr "Роботы, выполняющие задачи по расписанию. Могут подключаться к таймерам и использовать низкоуровневое API сайта для сбора и обработки данных. Они представляют собой код, который работает прямо внутри системы"))

;; (upd-role (get-role 3) (list :descr "Роботы, выполняющие тестирование внешних API сайта. Могу подключаться к таймерам и использовать внешнее REST-API сайта по протоколам взаимодейтствия, определенным для внешних агентов. Они представляют собой код, который работает как сторонняя программа, возможно даже на другой машине"))

;; (upd-role (get-role 4) (list :name "agent" :descr "Сторонние программы и агенты (такие, как мобильные приложения), которые могут только использовать только внешнее REST-API системы"))
;; role_entity ends here
;; [[file:doc.org::*Пользователи (user)][user_automat]]
(define-automat user "Автомат пользователя"
  ((id serial)
   (name varchar)
   (password varchar)
   (email varchar)
   (firstname (or db-null varchar))
   (lastname (or db-null varchar))
   (phone (or db-null varchar))
   (mobilephone (or db-null varchar))
   (sex (or db-null varchar))
   (birth-day (or db-null varchar))
   (birth-month (or db-null varchar))
   (birth-year (or db-null varchar))
   (ts-create bigint)
   (ts-last bigint)
   (role-id (or db-null integer)))
  (:sended :unlogged :logged :unregistred)
  ((:unregistred :logged :registration)
   (:logged :unregistred :unregistration)
   (:unlogged :logged :enter)
   (:logged :unlogged :leave)
   (:unlogged :sended :forgot)
   (:sended :logged :remember)))

(with-connection *db-spec*
  (unless (table-exists-p "user")
    (query (:alter-table "user" :add-constraint "uniq_email" :unique "email"))
    (query (:alter-table "user" :add-constraint "uniq_name" :unique "name"))))
(with-connection *db-spec*
  (unless (table-exists-p "user")
    (query (:alter-table "user" :add-constraint "foreign_role" :foreign-key ("role_id") ("role" "id")))))
(defun registration ()
  "unregistred -> logged")
(defun unregistration ()
  "logged -> unregistred")
(defun enter ()
  "unlogged -> logged")
(defun leave ()
  "logged -> unlogged")
(defun forgot ()
  "unlogged -> sended")
(defun remember ()
  "sended -> logged")
;; user_automat ends here
;; [[file:doc.org::*Группы (group, user2group)][group_entity]]
(define-entity group "Сущность группы"
  ((id serial)
   (name varchar)
   (descr (or db-null varchar))
   (ts-create bigint)
   (author-id (or db-null integer))))

(make-group-table)

;; (make-group
;;  :name "Исполнитель желаний"
;;  :descr "Создатель штук, которых еще нет. Исправлятель штук, которые неправильно работают."
;;  :ts-create (get-universal-time)
;;  :author-id 1)
;; (make-group
;;  :name "Пропускать везде"
;;  :descr "Для этого пользователя нет запретных мест"
;;  :ts-create (get-universal-time)
;;  :author-id 1)
;; (make-group
;;  :name "Острый глаз"
;;  :descr "Обладает способностью замечать недоработки"
;;  :ts-create (get-universal-time)
;;  :author-id 1)
;; (make-group
;;  :name "Основатель"
;;  :descr "Был с нами еще до того как это стало мейнстримом"
;;  :ts-create (get-universal-time)
;;  :author-id 1)
;; (make-group
;;  :name "Рулевой"
;;  :descr "Управляет пользователями и назначает права доступа"
;;  :ts-create (get-universal-time)
;;  :author-id 1)
;; group_entity ends here
;; [[file:doc.org::*Группы (group, user2group)][user2group_entity]]
(define-entity user2group "Сущность связи пользователя и группы"
  ((id serial)
   (user-id integer)
   (group-id integer)))

(make-user2group-table)

(with-connection *db-spec*
  (unless (table-exists-p "user2group")
    (query (:alter-table "user2group" :add-constraint "on_del_user"  :foreign-key ("user_id") ("user" "id") :cascade))
    (query (:alter-table "user2group" :add-constraint "on_del_group" :foreign-key ("group_id") ("group" "id") :cascade))))
;; user2group_entity ends here
;; [[file:doc.org::*Сообщения (msg)][msg_automat]]
(define-automat msg "Автомат сообщения"
  ((id serial)
   (snd-id integer)
   (rcv-id integer)
   (msg varchar)
   (ts-create bigint)
   (ts-delivery bigint))
  (:delivered :undelivered)
  ((:undelivered :delivered :delivery)))

(defun delivery ()
  "undelivered -> delivered")
;; msg_automat ends here
;; [[file:doc.org::*Задачи (task)][task_automat]]
(define-automat task "Автомат задачи"
  ((id serial)
   (name varchar)
   (blockdata varchar)
   (owner-id (or db-null integer))
   (exec-id (or db-null integer))
   (ts-create bigint))
  (:terminated :cancelled :standby :inaction :new)
  ((:new :inaction :starttask)
   (:inaction :standby :stoptask)
   (:standby :inaction :restarttask)
   (:new :cancelled :cancelnewtask)
   (:inaction :cancelled :cancelactiontask)
   (:standby :cancelled :cancelstandbytask)
   (:inaction :terminated :terminateactiontask)
   (:standby :terminated :terminatestandbytask)))

(with-connection *db-spec*
  (unless (table-exists-p "task")
    (query (:alter-table "task" :add-constraint "task_name" :unique "name"))))
(in-package #:asp)

(with-connection *db-spec*
  (unless (table-exists-p "task")
    (query (:alter-table "task" :add-constraint "on_del_user" :foreign-key ("owner_id") ("user" "id") :cascade))))
(defun starttask ()
  "new -> inaction")
(defun stoptask ()
  "inaction -> standby")
(defun restarttask ()
  "standby -> inaction")
(defun cancelnewtask ()
  "new -> cancelled")
(defun cancelactiontask ()
  "inaction -> cancelled")
(defun cancelstandbytask ()
  "standby -> cancelled")
(defun terminateactiontask ()
  "inaction -> action")
(defun terminatestandbytask ()
  "standby -> terminated")
;; task_automat ends here
;; [[file:doc.org::*Очереди (que, quelt)][que_entity]]
(define-entity que "Сущность очереди"
  ((id serial)
   (name varchar)))

(make-que-table)

(define-entity quelt "Сущность элемента очереди"
  ((id serial)
   (que-id integer)
   (text varchar)))

(make-quelt-table)

;; (make-que :name "admin")
;; (make-que :name "manager")
;; (make-que :name "moderator")
;; (make-que :name "robot")
;; que_entity ends here
