import { NFTStorage, File } from "nft.storage";
import { getFilesFromPath } from "files-from-path";
import mime from "mime";
import fs from "fs";
import path from "path";
import dotenv from "dotenv";
dotenv.config();

const nftStorageApiKey = process.env.NFT_STORAGE_API_KEY;

async function fileFromPath(filePath: string) {
  const content = await fs.promises.readFile(filePath);
  const type: string = mime.getType(filePath) as string;

  return new File([content], path.basename(filePath), { type });
}

async function uploadImageToIpfs(id: string, imagesDirPath: string) {
  const imagePath = path.join(imagesDirPath, `${id}.jpeg`);
  const image = await fileFromPath(imagePath);

  const storage = new NFTStorage({ token: nftStorageApiKey! });
  const imageCid = await storage.storeBlob(image);
  return imageCid;
}
