terraform {
  backend "s3" {
    bucket = "isitmy.lastdayat.work-tfstate"
    key    = "isitmy.lastdayat.work"
    region = "eu-west-1"
  }
}
