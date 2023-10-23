export interface Yacht {
  yachtId: string;
  price: number;
  name: string;
  maxCapacity: number;
  description: string;
}

export interface YachtWithEmbeddings extends Yacht {
  descriptionEmbedding: number[];
}
