#include <ROOT/TTreeProcessorMT.hxx>


int imt101_parTreeProcessing()
    {
      // First enable implicit multi-threading globally, so that the implicit parallelisation is on.
      // The parameter of the call specifies the number of threads to use.
      int nthreads = 4;
      ROOT::EnableImplicitMT(nthreads);
    
      // Create one TThreadedObject per histogram to fill during the processing of the tree
      ROOT::TThreadedObject<TH1F> ptHist("pt_dist","p_{T} Distribution;p_{T};dN/p_{T}dp_{T}", 100, 0, 5);
      ROOT::TThreadedObject<TH1F> pzHist("pz_dist","p_{Z} Distribution;p_{Z};dN/dp_{Z}", 100, 0, 5);
      ROOT::TThreadedObject<TH2F> pxpyHist("px_py","p_{X} vs p_{Y} Distribution;p_{X};p_{Y}", 100, -5., 5., 100, -5., 5.);
    
      // Create a TTreeProcessorMT: specify the file and the tree in it
      ROOT::TTreeProcessorMT tp("http://root.cern.ch/files/tp_process_imt.root",
                                "events");
    
      // Define the function that will process a subrange of the tree.
      // The function must receive only one parameter, a TTreeReader,
      // and it must be thread safe. To enforce the latter requirement,
      // TThreadedObject histograms will be used.
      auto myFunction = [&](TTreeReader &myReader) {
         TTreeReaderValue<std::vector<ROOT::Math::PxPyPzEVector>> tracksRV(myReader, "tracks");
    
         // For performance reasons, a copy of the pointer associated to this thread on the
         // stack is used
         auto myPtHist = ptHist.Get();
         auto myPzHist = pzHist.Get();
         auto myPxPyHist = pxpyHist.Get();
    
         while (myReader.Next()) {
            auto tracks = *tracksRV;
            for (auto&& track : tracks) {
               myPtHist->Fill(track.Pt(), 1./track.Pt());
               myPxPyHist->Fill(track.Px(), track.Py());
    
               myPzHist->Fill(track.Pz());
            }
         }
      };
    
      // Launch the parallel processing of the tree
      tp.Process(myFunction);
    
      // Use the TThreadedObject::Merge method to merge the thread private histograms
      // into the final result
      auto ptHistMerged   = ptHist.Merge();
      auto pzHistMerged   = pzHist.Merge();
      auto pxpyHistMerged = pxpyHist.Merge();
    
      return 0;
    }
