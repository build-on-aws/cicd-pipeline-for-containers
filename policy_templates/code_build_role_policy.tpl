{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:${region}:${account_id}:log-group:/aws/demo-codebuild-projects",
                "arn:aws:logs:${region}:${account_id}:log-group:codebuild-*-log-group:*",
                "arn:aws:logs:${region}:${account_id}:log-group:codebuild-log-group:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::code-pipeline-${region}-*"
            ],
            "Action": [
                "s3:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "codebuild:BatchPutCodeCoverages"
            ],
            "Resource": [
                "arn:aws:codebuild:${region}:${account_id}:report-group/demo-codebuild-projects-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "eks:Describe*",
            "Resource": "*"
        },
        {
        "Action": [
            "ecr:BatchCheckLayerAvailability",
            "ecr:CompleteLayerUpload",
            "ecr:GetAuthorizationToken",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart"
        ],
        "Resource": "*",
        "Effect": "Allow"
        },
         {
        "Action": [
            "eks:DescribeCluster",
            "eks:ListClusters"
        ],
        "Resource": "*",
        "Effect": "Allow"
        }
    ]
}
