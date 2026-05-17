using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Web.UI;
using System.IO;
using BL.GSTP.AHC;
using BL.GSTP.TP_THADS;
using BL.GSTP.BANGSETGET;
using System.Text.RegularExpressions;
using System.Net;
using System.Configuration;
using Newtonsoft.Json;
using System.Text;
using BL.GSTP.ADS;

namespace WEB.GSTP.QLAN.AHC.XuLyDon.Popup
{
    public partial class pMienAnPhi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                //string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "", bienphap = dropBienPhapGQ.SelectedValue;
                //decimal DONID = Convert.ToDecimal(current_id);
                //AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                //hddNgayNhanDon.Value = oDon.NGAYNHANDON + "" == "" ? "" : ((DateTime)oDon.NGAYNHANDON).ToString("dd/MM/yyyy");
                try
                {
                    //    txtNgayGQ.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    //    LoadDropBienPhapGQ(false);
                    //    //pnCDTN.Visible = pnCDNN.Visible = pnTraDon.Visible = false;
                    //    //pnThongbao.Visible = false;
                    //    LoadDSTL();
                    LoadGrid_AnPhi();
                }
                catch (Exception ex) { lbThongbaoAP.Text = ex.Message; }
            }
        }

        protected void cmdCapNhatAP_Click(object sender, EventArgs e)
        {
            if (!CheckValidAP())
            {
                return;
            }
            try
            {
                string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                decimal APId = Convert.ToDecimal(Request.QueryString["ID"]);
                String strMsg = "";

                DON_MIENANPHI_BL dON_MIENANPHI_BL = new DON_MIENANPHI_BL();
                DataTable dataTable = dON_MIENANPHI_BL.GET_DON_MIENANPHI_BY_ANPHI_ID(APId, 6);

                //-------Update bang an phi------------
                AHC_ANPHI objAP = new AHC_ANPHI();
                #region Update bang an phi
                try
                {
                    objAP = dt.AHC_ANPHI.Where(x => x.ID == APId).FirstOrDefault();

                    string CONTENT_JSON = "";
                    string CONTENT_JSON_OLD = "";
                    if ((dataTable != null && dataTable.Rows.Count > 0 && hddHistoryId.Value != "") || hddHistoryId.Value == "")
                    {
                        // Chuyển đối tượng thành chuỗi JSON

                        string v_lydo = txtLyDo.Text;
                        string v_sothongbao = txtSothongbaoAP.Text;
                        string v_stb_phu = ddlStbPhuAP.SelectedValue;
                        DateTime d_ngaythongbao = (txtNgaythongbaoAP.Text == null || txtNgaythongbaoAP.Text.Trim() == "") ? DateTime.Now : DateTime.Parse(this.txtNgaythongbaoAP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        decimal ID_MIENANPHI = 0;
                        DateTime? ngaytao = null;
                        string nguoitao = "";
                        DateTime? ngaysua = null;
                        string nguoisua = "";
                        if (hddHistoryId.Value != "")
                        {
                            CONTENT_JSON_OLD = JsonConvert.SerializeObject(dataTable.Rows[0], Formatting.Indented);
                            ID_MIENANPHI = Convert.ToDecimal(hddHistoryId.Value);
                            ngaysua = DateTime.Now;
                            nguoisua = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        }
                        else
                        {
                            ngaytao = DateTime.Now;
                            nguoitao = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        }

                        decimal Mienanphi_ID = dON_MIENANPHI_BL.UPSERT_DON_MIENANPHI(ID_MIENANPHI, APId, DONID, 6, v_lydo, nguoitao, ngaytao, nguoisua, ngaysua, v_sothongbao, d_ngaythongbao, v_stb_phu);

                        DataTable dataMienAnphi = dON_MIENANPHI_BL.GET_DON_MIENANPHI_BY_ID(Mienanphi_ID);
                        CONTENT_JSON = JsonConvert.SerializeObject(dataMienAnphi.Rows[0], Formatting.Indented);
                    }
                    else
                    {
                        CONTENT_JSON_OLD = JsonConvert.SerializeObject(objAP, Formatting.Indented);

                        objAP.GHICHU = txtLyDo.Text;
                        objAP.SOTHONGBAO = txtSothongbaoAP.Text;
                        objAP.STB_PHU = ddlStbPhuAP.SelectedValue;
                        objAP.NGAYTHONGBAO = (txtNgaythongbaoAP.Text == null || txtNgaythongbaoAP.Text.Trim() == "") ? DateTime.Now : DateTime.Parse(this.txtNgaythongbaoAP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        objAP.NGAYSUA = DateTime.Now;
                        objAP.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                        CONTENT_JSON = JsonConvert.SerializeObject(objAP, Formatting.Indented);

                        dt.SaveChanges();
                    }

                    //anhpn add log án phí 08/01/2025
                    string MATHONGBAO = "";
                    var DVCQG_THANH_TOAN = DataExtensions.GetAllWithClause<BL.GSTP.BANGSETGET.DVCQG_THANH_TOAN>("ANPHI_ID = " + APId + " AND MALOAIVUVIEC = '6'");
                    if (DVCQG_THANH_TOAN.Count() > 0)
                    {
                        MATHONGBAO = DVCQG_THANH_TOAN.FirstOrDefault().MA_THONGBAO;
                    }

                    LOG_THONGTINANPHI_QLTA log = new LOG_THONGTINANPHI_QLTA();
                    log.InsertLog(DONID.ToString(), objAP.ID.ToString(), MATHONGBAO, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Update", CONTENT_JSON, CONTENT_JSON_OLD);

                    // VNPT biểu mẫu in miễn án phí
                    AHC_DON aDS_DON = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    DM_BIEUMAU bmMienAnPhi = dt.DM_BIEUMAU.Where(x => x.MABM == "100-DS").FirstOrDefault();
                    AHC_FILE objFile = dt.AHC_FILE.Where(x => x.DONID == DONID && x.BIEUMAUID == bmMienAnPhi.ID).FirstOrDefault();
                    if (objFile != null)
                    {
                        UploadFileID(aDS_DON, objFile.ID, "100-DS", objAP.SOTHONGBAO, objAP.STB_PHU);
                    }
                    else
                    {
                        UploadFileID(aDS_DON, 0, "100-DS", objAP.SOTHONGBAO, objAP.STB_PHU);
                    }
                }
                catch (Exception ex) { }
                #endregion

                hddHistoryId.Value = "";
                //-------------------------------------
                hddPageIndexAP.Value = "1";
                LoadGrid_AnPhi();
                ResetcontrolAP();
                Cls_Comon.SetButton(cmdCapNhatAP, true);
                //Cls_Comon.SetButton(cmdThemmoiAP, true);
                strMsg = "Lưu thành công!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
            }
            catch (Exception ex) { lbThongbaoAP.Text = ex.Message; }
        }

        private decimal UploadFileID(AHC_DON oDon, decimal FileID, string strMaBieumau, string STT, string stb_Phu)
        {
            AHC_DON_BL oBL = new AHC_DON_BL();
            decimal IDFIle = 0;
            decimal IDBM = 0;
            string strTenBM = "";
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            try
            {
                AHC_FILE objFile = new AHC_FILE();
                if (FileID > 0)
                    objFile = dt.AHC_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                objFile.DONID = oDon.ID;
                objFile.TOAANID = oDon.TOAANID;
                objFile.MAGIAIDOAN = oDon.MAGIAIDOAN;
                objFile.LOAIFILE = 0;
                objFile.BIEUMAUID = IDBM;
                objFile.NAM = DateTime.Now.Year;
                if (hddFilePath.Value != "")
                {
                    try
                    {
                        string strFilePath = "";
                        //if (chkKySo.Checked)
                        //{
                        string[] arr = hddFilePath.Value.Split('/');
                        strFilePath = arr[arr.Length - 1];
                        strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                        //}
                        //else
                        //    strFilePath = hddFilePath.Value.Replace("/", "\\");
                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            objFile.NOIDUNG = buff;
                            objFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(strTenBM) + oF.Extension;
                            objFile.KIEUFILE = oF.Extension;
                        }
                        File.Delete(strFilePath);
                    }
                    catch (Exception ex) { lbThongbaoAP.Text = ex.Message; }
                }
                objFile.NGAYTAO = DateTime.Now;
                objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if (STT != "") objFile.STT = Convert.ToDecimal(STT);
                objFile.STB_PHU = stb_Phu;
                if (FileID == 0)
                {
                    // update 130825
                    objFile.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHC_FILE.Add(objFile);
                }

                dt.SaveChanges();
                IDFIle = objFile.ID;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }

            return IDFIle;
        }

        void ResetcontrolAP()
        {
            txtSothongbaoAP.Text = "";
            txtSothongbaoAP.Enabled = true;
            txtNgaythongbaoAP.Text = "";
            lbThongbaoAP.Text = "";
            txtLyDo.Text = "";
        }

        protected void lbTStepAP_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndexAP.Value = lbCurrent.Text;
            LoadGrid_AnPhi();
        }

        protected void lbTBackAP_Click(object sender, EventArgs e)
        {
            hddPageIndexAP.Value = (Convert.ToInt32(hddPageIndexAP.Value) - 1).ToString();
            LoadGrid_AnPhi();
        }

        protected void lbTFirstAP_Click(object sender, EventArgs e)
        {
            hddPageIndexAP.Value = "1";
            LoadGrid_AnPhi();
        }

        protected void lbTLastAP_Click(object sender, EventArgs e)
        {
            hddPageIndexAP.Value = Convert.ToInt32(hddTotalPageAP.Value).ToString();
            LoadGrid_AnPhi();
        }

        protected void lbTNextAP_Click(object sender, EventArgs e)
        {
            hddPageIndexAP.Value = (Convert.ToInt32(hddPageIndexAP.Value) + 1).ToString();
            LoadGrid_AnPhi();
        }

        private bool CheckValidAP()
        {
            decimal A_ANPHI_ID = Convert.ToDecimal(Request.QueryString["ID"].ToString());
            AHC_ANPHI objAnPhi = dt.AHC_ANPHI.Where(x => x.ID == A_ANPHI_ID).FirstOrDefault();

            if (objAnPhi == null)
            {
                lbThongbaoAP.Text = "Không tồn tại án phí để miễn!";
                return false;
            }

            DON_MIENANPHI_BL dON_MIENANPHI_BL = new DON_MIENANPHI_BL();
            DataTable dataTable = dON_MIENANPHI_BL.GET_DON_MIENANPHI_BY_ANPHI_ID(A_ANPHI_ID, 6);

            //decimal dsID = objAnPhi.DUONGSU_ID.Value;
            //decimal APId = A_ANPHI_ID;
            ///-----------------
            //AHC_ANPHI objAP = dt.AHC_ANPHI.Where(x => x.ID == APId).FirstOrDefault();
            //AHC_TONGDAT oTD = dt.AHC_TONGDAT.Where(x => x.DONID == objAP.DONID).FirstOrDefault();
            //if (oTD != null)
            //{
            //    lbThongbaoAP.Text = "Bạn không thể lưu khi đã tống đạt!";
            //    return false;
            //}

            //Ngay thong bao----------------------------
            if (String.IsNullOrEmpty(txtNgaythongbaoAP.Text))
            {
                String strMsg = "";
                strMsg = "Chưa nhập Ngày Thông báo";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                txtNgaythongbaoAP.Focus();
                return false;
            }
            if (String.IsNullOrEmpty(txtSothongbaoAP.Text))
            {
                String strMsg = "";
                strMsg = "Chưa nhập Số thông báo";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                txtSothongbaoAP.Focus();
                return false;
            }

            if (hddHistoryId.Value != "")
            {
                AHC_TONGDAT_BL dS_TONGDAT_BL = new AHC_TONGDAT_BL();
                if (dS_TONGDAT_BL.AHC_TONGDATDOITUONG_ANPHI_GETBYANPHIID_TONGDATID(objAnPhi.DONID, objAnPhi.ID).Rows.Count > 0)
                {
                    lbThongbaoAP.Text = "Bạn không thể sửa khi đã tống đạt!";
                    return false;
                }
            }


            if (hddHistoryId.Value + "" == "")
            {
                if (objAnPhi.TINHTRANG.Value == 1 || dataTable.Rows.Count > 0)
                {
                    lbThongbaoAP.Text = "Đối tượng đã được miễn án phí trước đó!";
                    return false;
                }
            }

            //string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
            //decimal? DONID = Convert.ToDecimal(current_id);
            //AHC_SOTHAM_THULY oTLST = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
            //AHC_DON oT = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            //if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oTLST != null)
            //{
            //    lbThongbaoAP.Text = "Bạn không thể lưu khi thụ lý sơ thẩm!";
            //    return false;
            //}


            return true;
        }

        class DuongSuTemp
        {
            public decimal DuongSuIdOld { get; set; }
            public decimal DuongSuIdNew { get; set; }
            public DuongSuTemp(decimal DuongSuIdOld, decimal DuongSuIdNew)
            {
                this.DuongSuIdOld = DuongSuIdOld;
                this.DuongSuIdNew = DuongSuIdNew;
            }
        }
        private void UpdateDuongSuIdTGTT(AHC_DON_THAMGIATOTUNG oTTOLD, AHC_DON_THAMGIATOTUNG oTTNEW, List<DuongSuTemp> lstDuongSuTemp)
        {
            string[] arrDuongSuId = oTTOLD.DUONGSUID.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            if (arrDuongSuId.Length > 0)
            {
                List<decimal> lstDuongSuIdOld = arrDuongSuId.Select(s => Convert.ToDecimal(s)).ToList();
                string strDuongSuIdNew = string.Join(",", lstDuongSuTemp.Where(s => lstDuongSuIdOld.Contains(s.DuongSuIdOld)).Select(s => s.DuongSuIdNew));
                if (strDuongSuIdNew.Length > 1)
                {
                    strDuongSuIdNew = "," + strDuongSuIdNew + ",";
                }
                oTTNEW.DUONGSUID = strDuongSuIdNew;
            }
        }

        protected void rptAP_ItemCommand(object source, DataGridCommandEventArgs e)
        {

            ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("lblDownloadAP"));

            decimal CurrMienanphiId = Convert.ToDecimal(e.CommandArgument.ToString());
            DON_MIENANPHI_BL dON_MIENANPHI_BL = new DON_MIENANPHI_BL();
            DataTable donMienanphi = dON_MIENANPHI_BL.GET_DON_MIENANPHI_BY_ID(CurrMienanphiId);
            decimal CurrID = 0;
            if (CurrMienanphiId != 0)
            {
                CurrID = Convert.ToDecimal(donMienanphi.Rows[0]["ANPHI_ID"].ToString());
            }
            else
            {
                CurrID = Convert.ToDecimal(Request.QueryString["ID"].ToString());
            }

            switch (e.CommandName)
            {
                case "DownloadAP":
                    DVCQG_FILE_BIENLAI oND = dt.DVCQG_FILE_BIENLAI.Where(x => x.ID == CurrID).FirstOrDefault();
                    if (oND.FILE_NAME != "")
                    {
                        //---Get file blob-----------
                        HiddenField hd_DownloadAP = (HiddenField)e.Item.FindControl("hd_DownloadAP");
                        String ND_id = hd_DownloadAP.Value;
                        String[] ND_id_arr = ND_id.Split(';');
                        TUPHAP_ANPHI_BL M_Object = new TUPHAP_ANPHI_BL();
                        String _FILE_NAME = "";
                        byte[] b = M_Object.File_Attach_Return(ND_id_arr[0], ref _FILE_NAME);
                        if (b.Length < 10000)
                        {
                            //----------call API-- update lại trường FILE_ATTACH của bảng DVCQG_FILE_BIENLAI 
                            DataTable oDT = M_Object.GET_URL_DVC_THANHTOAN(ND_id_arr[1]);//get url biên lai
                            WebClient client = new WebClient();
                            string apiUrl = ConfigurationManager.AppSettings["File_Bien_Lai"];
                            CapNhatFileModel is_file = new CapNhatFileModel();
                            is_file.DVCQG_TT_ID = ND_id_arr[1];
                            if (oDT != null)
                            {
                                is_file.URLBIENLAI = oDT.Rows[0]["URLBIENLAI"] + "";
                            }
                            var input = is_file;
                            string inputJson = JsonConvert.SerializeObject(input);
                            client.Headers.Clear();
                            client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
                            client.Encoding = Encoding.UTF8;
                            string contents = client.UploadString(apiUrl, inputJson);
                            //----------call API-end
                            b = M_Object.File_Attach_Return(ND_id_arr[0], ref _FILE_NAME);
                            oND.FILE_ATTACH = b;
                        }
                        //------End----------
                        //var cacheKey = Guid.NewGuid().ToString("N");
                        //Context.Cache.Insert(key: cacheKey, value: oND.FILE_ATTACH, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.FILE_NAME + "&Extension=." + oND.FILE_NAME.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries)[1] + "';", true);
                        Load_Respon_File(_FILE_NAME, b);
                    }
                    break;
                case "SuaAP":
                    if (CurrMienanphiId == 0)
                    {
                        hddCurrAPID.Value = CurrMienanphiId.ToString();
                        LoadInfo_AnPhiDaMien(CurrID);
                    }
                    else
                    {
                        hddCurrAPID.Value = CurrMienanphiId.ToString();
                        LoadInfo_AnPhi(CurrMienanphiId);
                    }
                    break;
                case "XoaAP":
                    try
                    {
                        DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                        decimal _check_out = 0;
                        obj.CHECK_DELETE_ANPHI(CurrID, "6", ref _check_out);//anhvh check delete 06/09/2023
                        if (_check_out == 1)
                        {
                            AHC_ANPHI objAP = dt.AHC_ANPHI.Where(x => x.ID == CurrID).FirstOrDefault();
                            AHC_TONGDAT oTD = dt.AHC_TONGDAT.Where(x => x.DONID == objAP.DONID).FirstOrDefault();
                            AHC_TONGDAT_BL dS_TONGDAT_BL = new AHC_TONGDAT_BL();
                            if (dS_TONGDAT_BL.AHC_TONGDATDOITUONG_ANPHI_GETBYANPHIID_TONGDATID(objAP.DONID, objAP.ID).Rows.Count > 0)
                            {
                                lbThongbaoAP.Text = "Bạn không thể xóa khi đã tống đạt!";
                                return;
                            }
                            else
                            {
                                //anhpn add log án phí 08/01/2025
                                string CONTENT_JSON = JsonConvert.SerializeObject(objAP, Formatting.Indented);
                                string CONTENT_JSON_OLD = null;

                                if (CurrMienanphiId != 0)
                                {
                                    if (donMienanphi != null && donMienanphi.Rows.Count > 0)
                                    {
                                        CONTENT_JSON_OLD = JsonConvert.SerializeObject(donMienanphi.Rows[0], Formatting.Indented);
                                        dON_MIENANPHI_BL.DELETE_DON_MIENANPHI_BY_ID(CurrMienanphiId);
                                    }
                                    else
                                    {
                                        lbThongbaoAP.Text = "Miễn án phí không tồn tại để xóa!";
                                        return;
                                    }
                                }
                                else
                                {
                                    dt.AHC_ANPHI.Remove(objAP);

                                    dt.SaveChanges();

                                    CONTENT_JSON_OLD = JsonConvert.SerializeObject(objAP, Formatting.Indented);
                                    //DELETE DVCQG_THANH_TOAN-------------
                                    decimal _VALUE = 0;
                                    obj.DVCQG_THANH_TOAN_DELETE_ANPHI(CurrID, "6", ref _VALUE);
                                }

                                string MATHONGBAO = "";
                                var DVCQG_THANH_TOAN = DataExtensions.GetAllWithClause<BL.GSTP.BANGSETGET.DVCQG_THANH_TOAN>("ANPHI_ID = " + CurrID + " AND MALOAIVUVIEC = '6'");
                                if (DVCQG_THANH_TOAN.Count() > 0)
                                {
                                    MATHONGBAO = DVCQG_THANH_TOAN.FirstOrDefault().MA_THONGBAO;
                                }
                                LOG_THONGTINANPHI_QLTA log = new LOG_THONGTINANPHI_QLTA();
                                log.InsertLog(Session[ENUM_LOAIAN.AN_HANHCHINH].ToString(), CurrID.ToString(), MATHONGBAO, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Update", CONTENT_JSON, CONTENT_JSON_OLD);

                                lbThongbaoAP.Text = "Xóa thành công!";

                            }
                        }
                        else
                        {
                            lbThongbaoAP.Text = "Đã thanh toán hoặc đã tống đạt nên không thể xóa!";
                        }
                        //-------------
                        LoadGrid_AnPhi();
                    }
                    catch (Exception ex) { lbThongbaoAP.Text = ex.Message; }
                    break;
            }
        }

        protected void rptAP_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("lblDownloadAP"));
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                ImageButton lblSuaAP = (ImageButton)e.Item.FindControl("lblSuaAP");
                Cls_Comon.SetLinkButton(lblSuaAP, oPer.CAPNHAT);

                ImageButton lbtXoaAP = (ImageButton)e.Item.FindControl("lbtXoaAP");
                Cls_Comon.SetLinkButton(lbtXoaAP, oPer.XOA);

                string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHC_DON oT = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();

                decimal vAPID = Convert.ToDecimal(rowView.Row[1]);

                DAL.GSTP.DVCQG_THANH_TOAN oAP = dt.DVCQG_THANH_TOAN.Where(x => x.ANPHI_ID == vAPID && x.MALOAIVUVIEC == "6").FirstOrDefault();
                AHC_SOTHAM_THULY oTLST = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();

                // Kiểm tra xem đơn đã được trả lại (LOAIGIAIQUYET == 3) hay chưa
                AHC_DON_XULY tralaiDonXuly = dt.AHC_DON_XULY.Where(x => x.DONID == DONID && x.LOAIGIAIQUYET == 3).FirstOrDefault();

                DON_MIENANPHI_BL dON_MIENANPHI_BL1 = new DON_MIENANPHI_BL();
                DataTable dataTable1 = dON_MIENANPHI_BL1.GET_DON_MIENANPHI_BY_ANPHI_ID(vAPID, 6);

                /*1. Nếu vụ án đang trong giai đoạn phúc thẩm thì không được xóa
                  2. Nếu vụ án đã có thụ lý sơ thẩm thì không được xóa
                  3. Nếu vụ án đã có biên lai án phí thì không được sửa và xóa*/
                DateTime dateTime = dataTable1.Rows.Count > 0 ? Convert.ToDateTime(dataTable1.Rows[0]["NGAYTAO"].ToString()) : default(DateTime);

                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oTLST != null || (tralaiDonXuly != null && dateTime != null && dateTime < tralaiDonXuly.NGAYSUA))
                {
                    lblSuaAP.Visible = lbtXoaAP.Visible = false;
                }
                else if (oAP != null && oAP.TRANGTHAITHANHTOAN == 1)
                {
                    lblSuaAP.Visible = lbtXoaAP.Visible = false;
                }
                else
                {
                    AHC_ANPHI objAP = dt.AHC_ANPHI.Where(x => x.ID == vAPID).FirstOrDefault();
                    DON_MIENANPHI_BL dON_MIENANPHI_BL = new DON_MIENANPHI_BL();
                    DataTable dataTable = dON_MIENANPHI_BL.GET_DON_MIENANPHI_BY_ANPHI_ID(vAPID, 6);

                    if (((objAP != null && objAP.TINHTRANG == 1) || dataTable.Rows.Count > 0) && e.Item.ItemIndex == 0)
                    {
                        lblSuaAP.Visible = lbtXoaAP.Visible = true;
                    }
                    else
                    {
                        lblSuaAP.Visible = lbtXoaAP.Visible = false;
                    }

                    string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                    if (objAP != null && objAP.TINHTRANG == 1 && objAP.TOA_GIAIQUYET_ID.ToString() != donviID)
                    {
                        lblSuaAP.Visible = lbtXoaAP.Visible = false;
                    }
                }

                ImageButton lblDownloadAP = (ImageButton)e.Item.FindControl("lblDownloadAP");
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownloadAP.Visible = false;
                }
                else
                {
                    lblDownloadAP.Visible = true;
                }
            }
        }

        void Load_Respon_File(String _FILE_NAME, byte[] b)
        {
            string fileEx = "";
            if (_FILE_NAME.LastIndexOf('.') > 0)
            {
                fileEx = _FILE_NAME.Substring(_FILE_NAME.LastIndexOf('.'));
            }
            Response.Clear();
            Response.ContentEncoding = Encoding.Unicode;
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + _FILE_NAME);
            switch (fileEx)
            {
                case ".pdf": Response.ContentType = "application/pdf"; break;
                case ".dwg": Response.ContentType = "image/vnd.dwg"; break;
                case ".doc": Response.ContentType = "application/msword"; break;
                case ".docx": Response.ContentType = "application/vnd.openxmlformats-officeFileAttach.wordprocessingml.FileAttach"; break;
                case ".xls": Response.ContentType = "application/vnd.ms-excel"; break;
                case ".xlsx": Response.ContentType = "application/vnd.openxmlformats-officeFileAttach.spreadsheetml.sheet"; break;
                case ".gif": Response.ContentType = "image/gif"; break;
                case ".jpeg": Response.ContentType = "image/jpg"; break;
                case ".jpg": Response.ContentType = "image/jpg"; break;
                case ".png": Response.ContentType = "image/png"; break;
                default: Response.ContentType = "application/octet-stream"; break; //getMimeType(sExtention, oConnection);  
            }
            Response.BinaryWrite(b);
            Response.Flush();
            Response.End();
        }

        void SetNewSoTBAP()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            AHC_DON_BL oSTBL = new AHC_DON_BL();
            //Số Thông báo mới
            DateTime ngayTB;
            if (!String.IsNullOrEmpty(txtNgaythongbaoAP.Text))
                ngayTB = DateTime.Parse(this.txtNgaythongbaoAP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else
                ngayTB = DateTime.Now;

            String STTNew = oSTBL.GET_STB_ANPHI_NEW(DonViID, "AHC", ngayTB).ToString();
            txtSothongbaoAP.Text = STTNew;

        }

        protected void txtNgaythongbaoAP_TextChanged(object sender, EventArgs e)
        {
            SetNewSoTBAP();
        }

        void LoadInfo_AnPhi(Decimal CurrID)
        {
            string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
            decimal DONID = Convert.ToDecimal(current_id);

            hddHistoryId.Value = CurrID + "";
            DON_MIENANPHI_BL dON_MIENANPHI_BL = new DON_MIENANPHI_BL();
            DataTable donMienanphi = dON_MIENANPHI_BL.GET_DON_MIENANPHI_BY_ID(CurrID);
            if (donMienanphi != null && donMienanphi.Rows.Count > 0)
            {
                chkNopAnPhi.Checked = true;
                chkNopAnPhi.Enabled = false;
                txtSothongbaoAP.Text = donMienanphi.Rows[0]["SOTHONGBAO"]?.ToString();
                ddlStbPhuAP.Text = donMienanphi.Rows[0]["STB_PHU"]?.ToString();
                txtLyDo.Text = donMienanphi.Rows[0]["LYDO"]?.ToString(); ;
                //txtSothongbaoAP.Enabled = false;
                txtNgaythongbaoAP.Text = (donMienanphi.Rows[0]["NGAYTHONGBAO"] == null) ? "" : ((DateTime)donMienanphi.Rows[0]["NGAYTHONGBAO"]).ToString("dd/MM/yyyy", cul);
            }
        }

        void LoadInfo_AnPhiDaMien(Decimal CurrID)
        {
            string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
            decimal DONID = Convert.ToDecimal(current_id);

            hddHistoryId.Value = CurrID + "";
            AHC_ANPHI aDSAnphi = dt.AHC_ANPHI.Where(x => x.ID == CurrID).FirstOrDefault();
            if (aDSAnphi != null)
            {
                chkNopAnPhi.Checked = true;

                chkNopAnPhi.Enabled = false;
                txtSothongbaoAP.Text = aDSAnphi.SOTHONGBAO;
                ddlStbPhuAP.Text = aDSAnphi.STB_PHU;
                txtLyDo.Text = aDSAnphi.GHICHU;
                //txtSothongbaoAP.Enabled = false;
                txtNgaythongbaoAP.Text = (aDSAnphi.NGAYTHONGBAO == null) ? "" : ((DateTime)aDSAnphi.NGAYTHONGBAO).ToString("dd/MM/yyyy", cul);
            }
        }

        private void LoadGrid_AnPhi()
        {
            AHC_DON_BL oBL = new AHC_DON_BL();
            string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            int page_size = 20, count_all = 0;
            int pageindex = Convert.ToInt32(hddPageIndexAP.Value);
            decimal A_ANPHI_ID = Convert.ToDecimal(Request.QueryString["ID"].ToString());
            DataTable oDT = oBL.AHC_ANPHI_LICHSU_GETBYDONID(DONID, A_ANPHI_ID, 1, pageindex, page_size);
            //if (oDT.Rows.Count > 0)
            //{
            //    count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            //    #region "Xác định số lượng trang"
            //    hddTotalPageAP.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
            //    lstSobanghiTAP.Text = lstSobanghiBAP.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPageAP.Value + "</b> trang";
            //    Cls_Comon.SetPageButton(hddTotalPageAP, hddPageIndexAP, lbTFirstAP, lbBFirstAP, lbTLastAP, lbBLastAP, lbTNextAP, lbBNextAP, lbTBackAP, lbBBackAP, lbTStep1AP, lbBStep1AP, lbTStep2AP,
            //                 lbBStep2AP, lbTStep3AP, lbBStep3AP, lbTStep4AP, lbBStep4AP, lbTStep5AP, lbBStep5AP, lbTStep6AP, lbBStep6AP);
            //    #endregion     
            //}
            //else
            //{
            //    hddTotalPageAP.Value = "1";
            //    Cls_Comon.SetPageButton(hddTotalPageAP, hddPageIndexAP, lbTFirstAP, lbBFirstAP, lbTLastAP, lbBLastAP, lbTNextAP, lbBNextAP, lbTBackAP, lbBBackAP, lbTStep1AP, lbBStep1AP, lbTStep2AP,
            //               lbBStep2AP, lbTStep3AP, lbBStep3AP, lbTStep4AP, lbBStep4AP, lbTStep5AP, lbBStep5AP, lbTStep6AP, lbBStep6AP);
            //    lstSobanghiTAP.Text = lstSobanghiBAP.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            //}

            rptAP.DataSource = oDT;
            rptAP.DataBind();
        }
    }


}