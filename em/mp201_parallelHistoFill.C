const UInt_t poolSize = 24U;
 Int_t mp201_parallelHistoFill()
 {

    cout << poolSize << endl;
    TH1::AddDirectory(false);
    ROOT::TProcessExecutor pool(poolSize);
    auto fillRandomHisto = [](std::vector<double> seed) {
       TFile* f = TFile::Open("BDT_allyear_trim.root");
       double S_vbf = 0;
       double S_gg = 0;
       double B_vbf = 0;
       double B_gg = 0;
       cout << "Scanning Mjj " << seed[0] << " and dE " << seed[1] << endl;
       TTreeReader Breader("TreeB", f);
       TTreeReaderValue<float> BNj(Breader, "Nj");
       TTreeReaderValue<float> BMjj(Breader, "j1_j2_mass");
       TTreeReaderValue<float> Bw(Breader, "weight");
       TTreeReaderValue<float> BdE(Breader, "DeltaEta_j1_j2");
     
       while (Breader.Next()) {
         if (*BNj == 2 and *BMjj > seed[0] and *BdE > seed[1]) {
           B_vbf+=*Bw;
         }
         else {
           B_gg+=*Bw;
         }
       }
       cout << "B done" << endl;

       TTreeReader Sreader("TreeS", f);
       TTreeReaderValue<float> SNj(Sreader, "Nj");
       TTreeReaderValue<float> SMjj(Sreader, "j1_j2_mass");
       TTreeReaderValue<float> Sw(Sreader, "weight");
       TTreeReaderValue<float> SdE(Sreader, "DeltaEta_j1_j2");

       while (Sreader.Next()) {
         if (*SNj == 2 and *SMjj > seed[0] and *SdE > seed[1]) {
           S_vbf+=*Sw;
         }
         else {
           S_gg+=*Sw;
         }
       }
       cout << "S done" << endl;
     
       double sen = TMath::Power(S_vbf,2)/B_vbf + TMath::Power(S_gg,2)/B_gg;
       auto h = new TH2F("sen", "sen", 17, 1.9, 3.6, 17, 390, 560);
       h->Fill(seed[1], seed[0],sen);
       return h;
    };
 
    std::vector<std::vector<double>> vec;
    for (double mjj = 400; mjj < 560; mjj+=10){ //560
     for (double eta = 2; eta < 3.6; eta+=.1){ //3.5
       vec.push_back({mjj,eta});
     }
    } 
    ROOT::ExecutorUtils::ReduceObjects<TH2F *> redfunc;
    auto sumRandomHisto = pool.MapReduce(fillRandomHisto, vec, redfunc);
 
    TFile* f = new TFile("try1.root","recreate");
    auto c = new TCanvas();
    sumRandomHisto->Draw();
    sumRandomHisto->Write();
    f->Close();
    return 0;
 }
