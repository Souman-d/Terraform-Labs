resource "aws_s3_bucket" "terra-bucket-123456789-som" {
  bucket = "terra-bucket-123456789-som"
  
  }
  
resource "aws_s3_object" "bucket_data" {
  bucket = aws_s3_bucket.terra-bucket-123456789-som.bucket
  source = "./demofile.txt"
  key    = "mydata.txt"
}  