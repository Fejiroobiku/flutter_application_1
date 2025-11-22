import { 
  collection, 
  addDoc, 
  getDocs, 
  query, 
  orderBy, 
  Timestamp 
} from 'firebase/firestore';
import { db } from './firebase';

export interface ImageDocument {
  id?: string;
  imageUrl: string;
  imageId: string;
  fileName: string;
  uploadedAt: Date;
  description?: string;
  tags?: string[];
}

// Store image metadata after ImageKit upload
export const storeImageMetadata = async (imageData: Omit<ImageDocument, 'id' | 'uploadedAt'>) => {
  try {
    const docRef = await addDoc(collection(db, 'images'), {
      ...imageData,
      uploadedAt: Timestamp.now()
    });
    return docRef.id;
  } catch (error) {
    console.error('Error storing image metadata:', error);
    throw error;
  }
};

// Get all images with metadata
export const getImagesMetadata = async (): Promise<ImageDocument[]> => {
  try {
    const q = query(collection(db, 'images'), orderBy('uploadedAt', 'desc'));
    const querySnapshot = await getDocs(q);
    
    const images: ImageDocument[] = [];
    querySnapshot.forEach((doc) => {
      const data = doc.data();
      images.push({
        id: doc.id,
        imageUrl: data.imageUrl,
        imageId: data.imageId,
        fileName: data.fileName,
        uploadedAt: data.uploadedAt.toDate(),
        description: data.description,
        tags: data.tags || []
      });
    });
    
    return images;
  } catch (error) {
    console.error('Error getting images metadata:', error);
    throw error;
  }
};