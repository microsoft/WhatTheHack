import { Router } from "express"
import usersCtrl from "./users.controller"
import commentsCtrl from "./comments.controller"

const router = new Router()

// associate put, delete, and get(id)
router.route("/register").post(usersCtrl.register)
router.route("/login").post(usersCtrl.login)
router.route("/logout").post(usersCtrl.logout)
router.route("/delete").delete(usersCtrl.delete)
router.route("/update-preferences").put(usersCtrl.save)
router.route("/comment-report").get(commentsCtrl.apiCommentReport)
router.route("/make-admin").post(usersCtrl.createAdminUser)

export default router
