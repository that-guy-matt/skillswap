/*
  Warnings:

  - You are about to drop the `CategoriesOnSkills` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Category` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Connection` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `SearchingSkill` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Skill` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `UserSkill` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "links_status" AS ENUM ('PENDING', 'ACCEPTED', 'DECLINED');

-- DropForeignKey
ALTER TABLE "CategoriesOnSkills" DROP CONSTRAINT "CategoriesOnSkills_categoryId_fkey";

-- DropForeignKey
ALTER TABLE "CategoriesOnSkills" DROP CONSTRAINT "CategoriesOnSkills_skillId_fkey";

-- DropForeignKey
ALTER TABLE "Connection" DROP CONSTRAINT "Connection_receiverId_fkey";

-- DropForeignKey
ALTER TABLE "Connection" DROP CONSTRAINT "Connection_requesterId_fkey";

-- DropForeignKey
ALTER TABLE "SearchingSkill" DROP CONSTRAINT "SearchingSkill_skillId_fkey";

-- DropForeignKey
ALTER TABLE "SearchingSkill" DROP CONSTRAINT "SearchingSkill_userId_fkey";

-- DropForeignKey
ALTER TABLE "UserSkill" DROP CONSTRAINT "UserSkill_skillId_fkey";

-- DropForeignKey
ALTER TABLE "UserSkill" DROP CONSTRAINT "UserSkill_userId_fkey";

-- DropTable
DROP TABLE "CategoriesOnSkills";

-- DropTable
DROP TABLE "Category";

-- DropTable
DROP TABLE "Connection";

-- DropTable
DROP TABLE "SearchingSkill";

-- DropTable
DROP TABLE "Skill";

-- DropTable
DROP TABLE "User";

-- DropTable
DROP TABLE "UserSkill";

-- DropEnum
DROP TYPE "ConnectionStatus";

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "first_name" TEXT,
    "last_name" TEXT,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "bio" TEXT,
    "location" TEXT,
    "contact_info" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_skills" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "skill_id" INTEGER NOT NULL,
    "proficiency" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_skills_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "searching_skills" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "skill_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "searching_skills_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "skills" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "skills_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "category_skills" (
    "id" SERIAL NOT NULL,
    "skill_id" INTEGER NOT NULL,
    "category_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "category_skills_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "links" (
    "id" SERIAL NOT NULL,
    "requester_id" INTEGER NOT NULL,
    "receiver_id" INTEGER NOT NULL,
    "status" "links_status" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "links_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- AddForeignKey
ALTER TABLE "user_skills" ADD CONSTRAINT "user_skills_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_skills" ADD CONSTRAINT "user_skills_skill_id_fkey" FOREIGN KEY ("skill_id") REFERENCES "skills"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "searching_skills" ADD CONSTRAINT "searching_skills_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "searching_skills" ADD CONSTRAINT "searching_skills_skill_id_fkey" FOREIGN KEY ("skill_id") REFERENCES "skills"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "category_skills" ADD CONSTRAINT "category_skills_skill_id_fkey" FOREIGN KEY ("skill_id") REFERENCES "skills"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "category_skills" ADD CONSTRAINT "category_skills_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "links" ADD CONSTRAINT "links_requester_id_fkey" FOREIGN KEY ("requester_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "links" ADD CONSTRAINT "links_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
