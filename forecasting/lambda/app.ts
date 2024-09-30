import { S3Handler, S3Event } from 'aws-lambda';
import { S3 } from 'aws-sdk';

const s3 = new S3({});

export const lambdaHandler: S3Handler = async (event: S3Event) => {
    const sourceBucket = event.Records[0].s3.bucket.name;
    const sourceKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
    const destinationBucket = 'aggregated-data-s3-bucket';

    try {
        const objectData = await s3.getObject({ Bucket: sourceBucket, Key: sourceKey }).promise();
        
        // Copy the object to the destination bucket
        await s3.putObject({
            Bucket: destinationBucket,
            Key: sourceKey,
            Body: objectData.Body,
            ContentType: objectData.ContentType 
        }).promise();
        
        console.log(`Successfully copied ${sourceKey} from ${sourceBucket} to ${destinationBucket}`);
    } catch(error: any) {
        console.error(`Error copying object: ${error.message}`);
    }
};
