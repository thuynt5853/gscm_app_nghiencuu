using BL.GSTP;
using BL.GSTP.TONGDAT;
using DAL.GSTP;
using DAL.DKK;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.TP_THADS;

namespace WEB.GSTP.QLAN.TONGDATTT
{
    public partial class pTongDat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        DKKContextContainer dkk = new DKKContextContainer();
        CultureInfo cul = new CultureInfo("vi-VN");

        public Decimal VuAnID = 0,vLoaian =0, vBieumauid = 0,  vTongDatID = 0;
        Decimal PhongBanID = 0, CurrDonViID = 0;

        public bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch { return false; }
        }
        public string GetTextDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return (Convert.ToDateTime(obj).ToString("dd/MM/yyyy", cul));
            }
            catch { return ""; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                vTongDatID = (String.IsNullOrEmpty(Request["vTDid"] + "")) ? 0 : Convert.ToDecimal(Request["vTDid"] + "");
                vLoaian = (String.IsNullOrEmpty(Request["vLoaian"] + "")) ? 0 : Convert.ToDecimal(Request["vLoaian"] + "");
                VuAnID = (String.IsNullOrEmpty(Request["vVuanid"] + "")) ? 0 : Convert.ToDecimal(Request["vVuanid"] + "");
                vBieumauid = (String.IsNullOrEmpty(Request["vBieumauid"] + "")) ? 0 : Convert.ToDecimal(Request["vBieumauid"] + "");

                if (!IsPostBack)
                {   
                    LoadCombobox();
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    
                    string TOAANID = CurrDonViID.ToString();
                   
                    decimal ID = Convert.ToDecimal(VuAnID), HinhThucNHanDon = 0, MAGIAIDOAN = 0;
                    hddarrDuongsuTructuyen.Value = "";
                    bool isTructuyen = false;

                    if (vLoaian == 1)
                    {
                        AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                        List<AHS_BICANBICAO> lstDSTT = dt.AHS_BICANBICAO.Where(x => x.VUANID == ID).ToList();
                        if (lstDSTT.Count > 0)
                            hddarrDuongsuTructuyen.Value = lstDSTT[0].ID.ToString();

                        List<DONKK_USER_DKNHANVB> lstDKVB = dkk.DONKK_USER_DKNHANVB.Where(x => x.VUVIECID == ID && x.MALOAIVUVIEC == ENUM_LOAIAN.AN_HINHSU && x.TRANGTHAI == 1).ToList();
                        if (lstDKVB.Count == 0)
                            lstDKNhanTD.Text = "Không có";
                        else
                        {
                            lstDKNhanTD.Text = "Có " + lstDKVB.Count.ToString() + " đương sự đăng ký nhận tống đạt trực tuyến";
                            isTructuyen = true;
                            foreach (DONKK_USER_DKNHANVB oDK in lstDKVB)
                            {
                                if (hddarrDuongsuTructuyen.Value == "")
                                    hddarrDuongsuTructuyen.Value = oDK.DUONGSUID + "";
                                else
                                    hddarrDuongsuTructuyen.Value += "," + oDK.DUONGSUID + "";
                            }
                        }
                    }
                    else
                    {
                         if (vLoaian == 2)
                        {
                            ADS_DON oT = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();
                            if (oT != null)
                            {
                                HinhThucNHanDon = oT.HINHTHUCNHANDON + "" == "" ? 0 : (decimal)oT.HINHTHUCNHANDON;
                                MAGIAIDOAN = oT.MAGIAIDOAN + "" == "" ? 0 : (decimal)oT.MAGIAIDOAN;
                                TOAANID = oT.TOAANID + "";
                            }
                        }
                        else if (vLoaian == 3)
                        {
                            AHN_DON oT = dt.AHN_DON.Where(x => x.ID == ID).FirstOrDefault();
                            if (oT != null)
                            {
                                HinhThucNHanDon = oT.HINHTHUCNHANDON + "" == "" ? 0 : (decimal)oT.HINHTHUCNHANDON;
                                MAGIAIDOAN = oT.MAGIAIDOAN + "" == "" ? 0 : (decimal)oT.MAGIAIDOAN;
                                TOAANID = oT.TOAANID + "";
                            }

                        }
                        else if (vLoaian == 4)
                        {
                            AKT_DON oT = dt.AKT_DON.Where(x => x.ID == ID).FirstOrDefault();
                            if (oT != null)
                            {
                                HinhThucNHanDon = oT.HINHTHUCNHANDON + "" == "" ? 0 : (decimal)oT.HINHTHUCNHANDON;
                                MAGIAIDOAN = oT.MAGIAIDOAN + "" == "" ? 0 : (decimal)oT.MAGIAIDOAN;
                                TOAANID = oT.TOAANID + "";
                            }
                        }
                        else if (vLoaian == 5)
                        {
                            ALD_DON oT = dt.ALD_DON.Where(x => x.ID == ID).FirstOrDefault();
                            if (oT != null)
                            {
                                HinhThucNHanDon = oT.HINHTHUCNHANDON + "" == "" ? 0 : (decimal)oT.HINHTHUCNHANDON;
                                MAGIAIDOAN = oT.MAGIAIDOAN + "" == "" ? 0 : (decimal)oT.MAGIAIDOAN;
                                TOAANID = oT.TOAANID + "";
                            }
                        }
                        else if (vLoaian == 6)
                        {
                            AHC_DON oT = dt.AHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                            if (oT != null)
                            {
                                HinhThucNHanDon = oT.HINHTHUCNHANDON + "" == "" ? 0 : (decimal)oT.HINHTHUCNHANDON;
                                MAGIAIDOAN = oT.MAGIAIDOAN + "" == "" ? 0 : (decimal)oT.MAGIAIDOAN;
                                TOAANID = oT.TOAANID + "";
                            }
                        }

                        if (HinhThucNHanDon == 1)
                            lstHinhthucgui.Text = "Trực tiếp";
                        else if (HinhThucNHanDon == 2)
                            lstHinhthucgui.Text = "Qua bưu điện";
                        else if (HinhThucNHanDon == 3)
                        {
                            lstHinhthucgui.Text = "Trực tuyến";
                            isTructuyen = true;
                            if (vLoaian == 1)
                            {
                                List<AHS_BICANBICAO> lstDSTT = dt.AHS_BICANBICAO.Where(x => x.VUANID == ID).ToList();
                                if (lstDSTT.Count > 0)
                                    hddarrDuongsuTructuyen.Value = lstDSTT[0].ID.ToString();
                            }
                            else if (vLoaian == 2)
                            {
                                List<ADS_DON_DUONGSU> lstDSTT = dt.ADS_DON_DUONGSU.Where(x => x.DONID == ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
                                if (lstDSTT.Count > 0)
                                    hddarrDuongsuTructuyen.Value = lstDSTT[0].ID.ToString();
                            }
                            else if (vLoaian == 3)
                            {
                                List<AHN_DON_DUONGSU> lstDSTT = dt.AHN_DON_DUONGSU.Where(x => x.DONID == ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
                                if (lstDSTT.Count > 0)
                                    hddarrDuongsuTructuyen.Value = lstDSTT[0].ID.ToString();
                            }
                            else if (vLoaian == 4)
                            {
                                List<AKT_DON_DUONGSU> lstDSTT = dt.AKT_DON_DUONGSU.Where(x => x.DONID == ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
                                if (lstDSTT.Count > 0)
                                    hddarrDuongsuTructuyen.Value = lstDSTT[0].ID.ToString();
                            }
                            else if (vLoaian == 5)
                            {
                                List<ALD_DON_DUONGSU> lstDSTT = dt.ALD_DON_DUONGSU.Where(x => x.DONID == ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
                                if (lstDSTT.Count > 0)
                                    hddarrDuongsuTructuyen.Value = lstDSTT[0].ID.ToString();
                            }
                            else if (vLoaian == 6)
                            {
                                List<AHC_DON_DUONGSU> lstDSTT = dt.AHC_DON_DUONGSU.Where(x => x.DONID == ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
                                if (lstDSTT.Count > 0)
                                    hddarrDuongsuTructuyen.Value = lstDSTT[0].ID.ToString();
                            }
                        }
                        List<DONKK_USER_DKNHANVB> lstDKVB = dkk.DONKK_USER_DKNHANVB.Where(x => x.VUVIECID == ID && x.MALOAIVUVIEC == ENUM_LOAIAN.AN_DANSU && x.TRANGTHAI == 1).ToList();
                        if (lstDKVB.Count == 0)
                            lstDKNhanTD.Text = "Không có";
                        else
                        {
                            lstDKNhanTD.Text = "Có " + lstDKVB.Count.ToString() + " đương sự đăng ký nhận tống đạt trực tuyến";
                            isTructuyen = true;
                            foreach (DONKK_USER_DKNHANVB oDK in lstDKVB)
                            {
                                if (hddarrDuongsuTructuyen.Value == "")
                                    hddarrDuongsuTructuyen.Value = oDK.DUONGSUID + "";
                                else
                                    hddarrDuongsuTructuyen.Value += "," + oDK.DUONGSUID + "";
                            }
                        }
                    }

                    if (isTructuyen)
                    {
                        hddIsTructuyen.Value = "1";
                        trFile.Visible = true;
                        chkKySo.Checked = true;
                        chkKySo.Enabled = false;
                        zonekyso.Style.Remove("Display");
                        zonekythuong.Style.Add("Display", "none");
                        
                    }
                    else
                    {
                        chkKySo.Checked = false;
                        chkKySo.Enabled = true;
                        zonekyso.Style.Add("Display", "none");
                        zonekythuong.Style.Remove("Display");

                        trFile.Visible = true;
                        hddIsTructuyen.Value = "0";
                    }

                    LoadbyddlBieumau();
                    LoadGrid();
                 
                }
                //trThemFile.Visible = true;
                //lbtDownload.Visible = false;
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadCombobox()
        {
            TONGDAT_BL oBL = new TONGDAT_BL();
            DataTable tbl = oBL.FILE_TONGDAT(vTongDatID,vLoaian,VuAnID);

            ddlBieumau.DataSource = tbl;
            ddlBieumau.DataTextField = "TENBM";
            ddlBieumau.DataValueField = "ID";
            ddlBieumau.DataBind();
            //ddlBieumau.Items.Insert(0, new ListItem("--- Chọn biểu mẫu ---", "0"));
            ddlBieumau.Enabled = false;
            
        }
        private void LoadbyddlBieumau()
        {
            TONGDAT_BL oBL = new TONGDAT_BL();
            DataTable tbl = oBL.FILE_TONGDAT(vTongDatID, vLoaian, VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                string vID = tbl.Rows[0]["BIEUMAUID"] + "";
                vBieumauid = Convert.ToDecimal(vID);
                trThemFile.Visible = false;
                LoadDoituong(false, vBieumauid);
                lbtDownload.Visible = false;
                //Hien thi file ky so
                decimal IDFILE = Convert.ToDecimal(tbl.Rows[0]["ID"]);
                string vTenFile = null;
                ADS_FILE oDS = null;
                AHS_FILE oHS = null;
                AHN_FILE oHN = null;
                AKT_FILE oKT = null;
                ALD_FILE oLD = null;
                AHC_FILE oHC = null;
                if (vLoaian == 1)
                {
                    oHS = dt.AHS_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                    if (oHS != null)
                        vTenFile = oHS.TENFILE;
                }
                else if (vLoaian == 2)
                {
                    oDS = dt.ADS_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                    if (oDS != null)
                        vTenFile = oDS.TENFILE;
                }
                else if (vLoaian == 3)
                {
                    oHN = dt.AHN_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                    if (oHN != null)
                        vTenFile = oHN.TENFILE;
                }
                else if (vLoaian == 4)
                {
                    oKT = dt.AKT_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                    if (oKT != null)
                        vTenFile = oKT.TENFILE;
                }
                else if (vLoaian == 5)
                {
                    oLD = dt.ALD_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                    if (oLD != null)
                        vTenFile = oLD.TENFILE;
                }
                else if (vLoaian == 6)
                {
                    oHC = dt.AHC_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                    if (oHC != null)
                        vTenFile = oHC.TENFILE;
                }

                if (vTenFile == null)
                {
                    //if (trTructuyen.Visible)
                    //{
                    trThemFile.Visible = true;
                    lbtDownload.Visible = false;
                    //}
                    //return;
                }
                else
                {
                    lbtDownload.Visible = true;
                    lbtDownload.Text = vTenFile;
                }
                hddFile.Value = IDFILE.ToString();

            }
        }
        //protected void btnKySo_Click(object sender, EventArgs e)
        //{
        //    decimal IDFILE = Convert.ToDecimal(hddFile.Value);
        //    AHN_FILE oF = dt.AHN_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
        //    if (oF != null)
        //    {
        //        if (oF.TENFILE != null)
        //        {
        //            var cacheKey = Guid.NewGuid().ToString("N");
        //            //Context.Cache.Insert(key: cacheKey, value: oF.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
        //            //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oF.TENFILE + "&Extension=" + oF.KIEUFILE + "';", true);
        //            ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "exc_sign_file_data('" + cacheKey + "','"+ oF.NOIDUNG + "')", true);
        //        }
        //    }
        //}

        private void ResetControls()
        {
            txtVKS_Ngaygui.Text = txtVKS_NgayNhan.Text = "";
            txtVKS_Ngaygui.Visible = lblVKSNgaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = false;
            rdbIsVKS.SelectedValue = "0";
            dgTructiep.DataSource = null;
            dgTructiep.DataBind();
            trDuongsu.Visible = trVKS.Visible = false;
            trTructuyen.Visible = false;
            trFile.Visible = false;
            //hddid.Value = "0";
            //lstTenBM.Text = "";
            //ddlBieumau.Visible = true;
            //lbtDownload.Visible = false;
            //cmdLammoi.Visible = false;
           
        }
        private bool CheckValid()
        {
            if (ddlBieumau.SelectedValue == "0" && ddlBieumau.Visible)
            {
                lbthongbao.Text = "Chưa chọn biểu mẫu cần tống đạt !";
                return false;
            }
            // Check nhap VKS khi can tong dat VKS
            if (trVKS.Visible)
            {
                if (rdbIsVKS.SelectedValue == "1")
                {
                    DateTime VKS_NgayGui, VKS_NgayNhan;
                    bool isValidate = DateTime.TryParse(txtVKS_Ngaygui.Text, cul, DateTimeStyles.NoCurrentDateDefault, out VKS_NgayGui);
                    if (txtVKS_Ngaygui.Text != "")
                    {
                        if (!isValidate)
                        {
                            lbthongbao.Text = "Ngày gửi đến Viện kiểm sát không đúng kiểu ngày / tháng / năm. Hãy nhập lại.";
                            txtVKS_Ngaygui.Focus();
                            return false;
                        }
                        else
                        {
                            if (DateTime.Compare(DateTime.Now, VKS_NgayGui) < 0)
                            {
                                lbthongbao.Text = "Ngày gửi đến Viện kiểm sát không được lớn hơn ngày hiện tại.";
                                txtVKS_Ngaygui.Focus();
                                return false;
                            }
                        }
                    }
                    if (txtVKS_NgayNhan.Text != "")
                    {
                        isValidate = DateTime.TryParse(txtVKS_NgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault, out VKS_NgayNhan);
                        if (!isValidate)
                        {
                            lbthongbao.Text = "Ngày Viện kiểm sát nhận không đúng kiểu ngày / tháng / năm. Hãy nhập lại.";
                            txtVKS_NgayNhan.Focus();
                            return false;
                        }
                        else
                        {
                            if (DateTime.Compare(DateTime.Now, VKS_NgayNhan) < 0)
                            {
                                lbthongbao.Text = "Ngày Viện kiểm sát nhận không được lớn hơn ngày hiện tại.";
                                txtVKS_NgayNhan.Focus();
                                return false;
                            }

                            if (txtVKS_NgayNhan.Text != "" && DateTime.Compare(VKS_NgayNhan, VKS_NgayGui) < 0)
                            {
                                lbthongbao.Text = "Ngày Viện kiểm sát nhận không được nhỏ hơn ngày gửi.";
                                txtVKS_NgayNhan.Focus();
                                return false;
                            }
                        }
                    }
                }
            }

            //Check Duong su truc tuyen
            if (trTructuyen.Visible && hddFilePath.Value == "" && lbtDownload.Visible == false)
            { 
                  lbthongbao.Text = "Chưa chọn tệp đính kèm để tống đạt trực tuyến !";
                  return false;
            }
            //Check duong su truc tiep
            if (trDuongsu.Visible && dgTructiep.Items.Count > 0)
            {
                bool IsChonDuongSu = false;
                foreach (DataGridItem Item in dgTructiep.Items)
                {
                    CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                    if (chkIsSend.Checked)
                    {
                        IsChonDuongSu = true;
                        DateTime NgayGui, NgayNhan;
                        bool isValidate = DateTime.TryParse(txtNgaygui.Text, cul, DateTimeStyles.NoCurrentDateDefault, out NgayGui);
                        if (txtNgaygui.Text != "")
                        {
                            if (!isValidate)
                            {
                                lbthongbao.Text = "Ngày gửi đến đương sự không đúng kiểu ngày / tháng / năm. Hãy nhập lại.";
                                txtNgaygui.Focus();
                                return false;
                            }
                            else
                            {
                                if (DateTime.Compare(DateTime.Now, NgayGui) < 0)
                                {
                                    lbthongbao.Text = "Ngày gửi đến đương sự không được lớn hơn ngày hiện tại.";
                                    txtNgaygui.Focus();
                                    return false;
                                }
                            }
                        }
                        if (txtNgayNhan.Text != "")
                        {
                            isValidate = DateTime.TryParse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault, out NgayNhan);
                            if (!isValidate)
                            {
                                lbthongbao.Text = "Ngày nhận không đúng kiểu ngày / tháng / năm. Hãy nhập lại.";
                                txtNgayNhan.Focus();
                                return false;
                            }
                            else
                            {
                                if (DateTime.Compare(DateTime.Now, NgayNhan) < 0)
                                {
                                    lbthongbao.Text = "Ngày nhận không được lớn hơn ngày hiện tại.";
                                    txtNgayNhan.Focus();
                                    return false;
                                }

                                if (txtNgayNhan.Text != "" && DateTime.Compare(NgayNhan, NgayGui) < 0)
                                {
                                    lbthongbao.Text = "Ngày nhận không được nhỏ hơn ngày gửi.";
                                    txtNgayNhan.Focus();
                                    return false;
                                }
                            }
                        }
                    }
                }
                if (!IsChonDuongSu)
                {
                    lbthongbao.Text = "Chưa chọn đương sự để tống đạt. Hãy chọn lại.";
                    return false;
                }
            }

            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            try
            {
                if (!CheckValid()) return;
                decimal DONID = Convert.ToDecimal(VuAnID);
                decimal TongDatID = vTongDatID;
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (vLoaian == 1)
                    SaveAnHS(ToaAnID, DONID, TongDatID);
                else if (vLoaian == 2)
                    SaveAnDS(ToaAnID, DONID, TongDatID);
                else if (vLoaian == 3)
                    SaveAnHN(ToaAnID, DONID, TongDatID);
                else if (vLoaian == 4)
                    SaveAnKT(ToaAnID, DONID, TongDatID);
                else if (vLoaian == 5)
                    SaveAnLD(ToaAnID, DONID, TongDatID);
                else if (vLoaian == 6)
                    SaveAnHC(ToaAnID, DONID, TongDatID);

                dgList.CurrentPageIndex = 0;
                /////////////////////
                ResetControls();
                if (trTructuyen.Visible)
                    lbthongbao.Text = "Lưu và gửi tống đạt trực tuyến thành công!";
                else
                    lbthongbao.Text = "Lưu thành công!";
                
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }

        private void SaveAnHS(decimal ToaAnID, decimal DONID, decimal TongDatID)
        {
            AHS_FILE oF = new AHS_FILE();
            AHS_TONGDAT oND = dt.AHS_TONGDAT.Where(x => x.ID == TongDatID).FirstOrDefault();

            oND.VUANID = VuAnID;
            oND.TOAANID = ToaAnID;

            oF = dt.AHS_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
            if (oF != null)
            {
                if (oF.TENFILE == null && trTructuyen.Visible)
                {
                    if (hddFilePath.Value == "")
                    {
                        lbthongbao.Text = "Biểu mẫu chưa được đính kèm file để tống đạt trực tuyến !";
                        return;
                    }
                    else
                    {
                        try
                        {
                            string strFilePath = "";
                            if (chkKySo.Checked)
                            {
                                string[] arr = hddFilePath.Value.Split('/');
                                strFilePath = arr[arr.Length - 1];
                                strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                            }
                            else
                                strFilePath = hddFilePath.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo objf = new FileInfo(strFilePath);
                                long numBytes = objf.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oF.NOIDUNG = buff;
                                oF.TENFILE = Cls_Comon.ChuyenTenFileUpload(objf.Name);
                                oF.KIEUFILE = objf.Extension;
                                dt.SaveChanges();
                            }
                            File.Delete(strFilePath);
                        }
                        catch (Exception ex) { lbthongbao.Text = ex.Message; }
                    }
                }
                oND.BIEUMAUID = oF.BIEUMAUID;
                oND.FILEID = oF.ID;
                oND.BICAOID = oF.BICAOID;
            }
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            dt.SaveChanges();

            if (trVKS.Visible)
            {
                oND.IS_TD_VKS = Convert.ToDecimal(rdbIsVKS.SelectedValue);
                if (rdbIsVKS.SelectedValue == "1")
                {
                    if (txtVKS_Ngaygui.Visible)
                        oND.IS_TD_VKS_NGAY = txtVKS_Ngaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_Ngaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (txtVKS_NgayNhan.Visible)
                        oND.NGAYNHANTONGDAT = txtVKS_NgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }
            }
            //Lưu thông tin tống đạt tới đương sự trực tiếp
            if (trDuongsu.Visible)
            {
                decimal TongdatID = oND.ID;
                foreach (DataGridItem Item in dgTructiep.Items)
                {
                    CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                    //DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");
                    //decimal vHinhthucgui = Convert.ToDecimal(ddlHinhthucgui.SelectedValue);

                    decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                    AHS_TONGDAT_DOITUONG oTD = dt.AHS_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).FirstOrDefault();
                    //oTD.TONGDATID = TongdatID;
                    //oTD.DUONGSUID = DuongsuID;
                    //oTD.MATUCACH = Item.Cells[1].Text;
                    //oTD.HINHTHUCGUI = vHinhthucgui;
                    //oTD.TRANGTHAI = 1;
                    if (chkIsSend.Checked)
                    {
                        oTD.NGAYGUI = txtNgaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oTD.NGAYNHANTONGDAT = txtNgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        // Nếu tống đạt văn bản
                        // là bản án sơ thẩm thì sẽ lưu AHS_SOTHAM_BANAN_BICAO
                        if (ddlBieumau.SelectedItem.Text.Contains("27-HS") || ddlBieumau.SelectedItem.Text.Contains("Bản án hình sự sơ thẩm") || lstTenBM.Text.Contains("Bản án hình sự sơ thẩm"))
                        {
                            Update_AHS_SOTHAM_BANAN_BICAO(VuAnID, DuongsuID, oTD.NGAYNHANTONGDAT);
                        }
                        // là bản án phúc thẩm thì sẽ lưu AHS_PHUCTHAM_BANAN_BICAO
                        if (ddlBieumau.SelectedItem.Text.Contains("28-HS") || ddlBieumau.SelectedItem.Text.Contains("Bản án hình sự phúc thẩm") || lstTenBM.Text.Contains("Bản án hình sự phúc thẩm"))
                        {
                            Update_AHS_PHUCTHAM_BANAN_BICAO(VuAnID, DuongsuID, oTD.NGAYNHANTONGDAT);
                        }
                    }
                    else
                    {
                        oTD.NGAYGUI = (DateTime?)null;
                        oTD.NGAYNHANTONGDAT = (DateTime?)null;
                    }

                    dt.SaveChanges();
                }
            }
            //Lưu thông tin tống đạt tới đương sự trực tuyến
            if (trTructuyen.Visible)
            {
                decimal TongdatID = oND.ID;
                foreach (DataGridItem Item in dgTructuyen.Items)
                {
                    decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                    AHS_TONGDAT_DOITUONG oTD = dt.AHS_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).FirstOrDefault();

                    oTD.NGAYGUI = DateTime.Now;
                    oTD.NGAYNHANTONGDAT = DateTime.Now;
                    dt.SaveChanges();
                    // Nếu tống đạt văn bản
                    // là bản án sơ thẩm thì sẽ lưu AHS_SOTHAM_BANAN_BICAO
                    if (ddlBieumau.SelectedItem.Text.Contains("27-HS") || ddlBieumau.SelectedItem.Text.Contains("Bản án hình sự sơ thẩm") || lstTenBM.Text.Contains("Bản án hình sự sơ thẩm"))
                    {
                        Update_AHS_SOTHAM_BANAN_BICAO(VuAnID, DuongsuID, oTD.NGAYNHANTONGDAT);
                    }
                    // là bản án phúc thẩm thì sẽ lưu AHS_PHUCTHAM_BANAN_BICAO
                    if (ddlBieumau.SelectedItem.Text.Contains("28-HS") || ddlBieumau.SelectedItem.Text.Contains("Bản án hình sự phúc thẩm") || lstTenBM.Text.Contains("Bản án hình sự phúc thẩm"))
                    {
                        Update_AHS_PHUCTHAM_BANAN_BICAO(VuAnID, DuongsuID, oTD.NGAYNHANTONGDAT);
                    }
                    //Gửi sang hệ thống ĐKK
                    List<DONKK_DON_VBTONGDAT> lstDKK = dkk.DONKK_DON_VBTONGDAT.Where(x => x.BIEUMAUID == oF.ID && x.MALOAIVUVIEC == ENUM_LOAIAN.AN_HINHSU && x.VUVIECID == VuAnID && x.DUONGSUID == DuongsuID).ToList();
                    DONKK_DON_VBTONGDAT oVBTD = new DONKK_DON_VBTONGDAT();
                    AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    if (lstDKK.Count > 0)
                    {
                        oVBTD = lstDKK[0];
                        oVBTD.NOIDUNGFILE = oND.NOIDUNGFILE;
                        oVBTD.TENFILE = oND.TENFILE;
                        oVBTD.LOAIFILE = oND.KIEUFILE;
                        if (oDon != null)
                            oVBTD.TENVUVIEC = oDon.TENVUAN;
                        oVBTD.TOAANID = ToaAnID;
                        dkk.SaveChanges();
                    }
                    else
                    {
                        if (oDon != null)
                            oVBTD.TENVUVIEC = oDon.TENVUAN;
                        oVBTD.TOAANID = ToaAnID;
                        oVBTD.VUVIECID = VuAnID;
                        oVBTD.BIEUMAUID = oF.ID;
                        oVBTD.MALOAIVUVIEC = ENUM_LOAIAN.AN_HINHSU;
                        oVBTD.DUONGSUID = DuongsuID;
                        oVBTD.TENVANBAN = ddlBieumau.SelectedItem.Text;
                        oVBTD.NGAYGUI = DateTime.Now;
                        oVBTD.NGAYNHANTONGDAT = DateTime.Now;
                        oVBTD.NOIDUNGFILE = oF.NOIDUNG;
                        oVBTD.TENFILE = oF.TENFILE;
                        oVBTD.LOAIFILE = oF.KIEUFILE;
                        dkk.SaveChanges();
                    }
                }
            }
        }
        private void SaveAnDS(decimal ToaAnID, decimal DONID, decimal TongDatID)
        {
            ADS_FILE oF = new ADS_FILE();
            ADS_TONGDAT oND = dt.ADS_TONGDAT.Where(x => x.ID == TongDatID).FirstOrDefault();

            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            oND.DONID = DONID;
            oND.TOAANID = ToaAnID;

            oF = dt.ADS_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
            if (oF != null)
            {   // Yeu cau phai dinh kem 
                //if (oF.TENFILE == null && trTructuyen.Visible)
                if (oF.TENFILE == null)
                {
                    if (hddFilePath.Value == "")
                    {
                        lbthongbao.Text = "Biểu mẫu chưa được đính kèm file để tống đạt!";
                        return;
                    }
                    else
                    {
                        try
                        {
                            string strFilePath = "";
                            if (chkKySo.Checked)
                            {
                                string[] arr = hddFilePath.Value.Split('/');
                                strFilePath = arr[arr.Length - 1];
                                strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                            }
                            else
                                strFilePath = hddFilePath.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo objf = new FileInfo(strFilePath);
                                long numBytes = objf.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oF.NOIDUNG = buff;
                                oF.TENFILE = Cls_Comon.ChuyenTenFileUpload(objf.Name);
                                oF.KIEUFILE = objf.Extension;
                                dt.SaveChanges();
                            }
                            File.Delete(strFilePath);
                        }
                        catch (Exception ex) { lbthongbao.Text = ex.Message; }
                    }
                }
                oND.FILEID = oF.ID;
                oND.BIEUMAUID = oF.BIEUMAUID;
            }
            dt.SaveChanges();

            if (trVKS.Visible)
            {
                oND.IS_TD_VKS = Convert.ToDecimal(rdbIsVKS.SelectedValue);
                if (rdbIsVKS.SelectedValue == "1")
                {
                    if (txtVKS_Ngaygui.Visible)
                        oND.IS_TD_VKS_NGAY = txtVKS_Ngaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_Ngaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (txtVKS_NgayNhan.Visible)
                        oND.NGAYNHANTONGDAT = txtVKS_NgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }
            }
            //Lưu thông tin tống đạt tới đương sự trực tiếp
            if (trDuongsu.Visible)
            {
                decimal TongdatID = oND.ID;
                foreach (DataGridItem Item in dgTructiep.Items)
                {
                    CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                    //DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");
                    //decimal vHinhthucgui = Convert.ToDecimal(ddlHinhthucgui.SelectedValue);

                    decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);

                    ADS_TONGDAT_DOITUONG oTD = dt.ADS_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).FirstOrDefault();
                    //oTD.TONGDATID = TongdatID;
                    //oTD.DUONGSUID = DuongsuID;
                    //oTD.MATUCACH = Item.Cells[1].Text;
                    //oTD.HINHTHUCGUI = vHinhthucgui;
                    //oTD.TRANGTHAI = 1;
                    if (chkIsSend.Checked)
                    {
                        oTD.NGAYGUI = txtNgaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oTD.NGAYNHANTONGDAT = txtNgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        // Nếu văn bản tống đạt là bản án sơ thẩm thì sẽ lưu ADS_SOTHAM_BANAN_ANPHI
                        if (ddlBieumau.SelectedItem.Text.ToLower().Contains("52-ds") || ddlBieumau.SelectedItem.Text.ToLower().Contains("bản án dân sự sơ thẩm") || lstTenBM.Text.ToLower().Contains("bản án dân sự sơ thẩm"))
                        {
                            Update_ADS_SOTHAM_BANAN_ANPHI(DONID, DuongsuID, oTD.NGAYNHANTONGDAT);
                        }
                    }
                    else
                    {
                        oTD.NGAYGUI = (DateTime?)null;
                        oTD.NGAYNHANTONGDAT = (DateTime?)null;
                    }
                    dt.SaveChanges();
                }

            }
            //Lưu thông tin tống đạt tới đương sự trực tuyến
            if (trTructuyen.Visible)
            {
                decimal TongdatID = oND.ID;
                foreach (DataGridItem Item in dgTructuyen.Items)
                {
                    decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                    //List<ADS_TONGDAT_DOITUONG> lstCheck = dt.ADS_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).ToList();
                    //ADS_TONGDAT_DOITUONG oTD = null;
                    ADS_TONGDAT_DOITUONG oTD = dt.ADS_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).FirstOrDefault();
                    if (oTD.NGAYGUI == null || ((DateTime)oTD.NGAYGUI).ToString("dd/MM/yyyy") == "01/01/0001")
                    {
                        oTD.NGAYGUI = DateTime.Now;
                        oTD.NGAYNHANTONGDAT = DateTime.Now;
                        dt.SaveChanges();
                        ///insert vào bảng DVCQG_THANH_TOAN
                        DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                        obj.DVCQG_THANH_TOAN_UP_TONGDAT(oND.ID, DuongsuID, "2");
                    }
                    // Nếu tống đạt văn bản
                    // là bản án sơ thẩm thì sẽ lưu ADS_SOTHAM_BANAN_ANPHI
                    if (ddlBieumau.SelectedItem.Text.Contains("52-DS") || ddlBieumau.SelectedItem.Text.Contains("Bản án dân sự sơ thẩm") || lstTenBM.Text.Contains("Bản án dân sự sơ thẩm"))
                    {
                        Update_ADS_SOTHAM_BANAN_ANPHI(DONID, DuongsuID, oTD.NGAYNHANTONGDAT);
                    }
                    //Gửi sang hệ thống ĐKK
                    List<DONKK_DON_VBTONGDAT> lstDKK = null;
                    if (oF != null)
                    {
                        lstDKK = dkk.DONKK_DON_VBTONGDAT.Where(x => x.BIEUMAUID == oF.ID && x.MALOAIVUVIEC == ENUM_LOAIAN.AN_DANSU && x.VUVIECID == DONID && x.DUONGSUID == DuongsuID).ToList();
                    }
                    DONKK_DON_VBTONGDAT oVBTD = new DONKK_DON_VBTONGDAT();
                    ADS_DON oDon = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    if (lstDKK != null && lstDKK.Count > 0)
                    {
                        oVBTD = lstDKK[0];
                        oVBTD.NOIDUNGFILE = oND.NOIDUNGFILE;
                        oVBTD.TENFILE = oND.TENFILE;
                        oVBTD.LOAIFILE = oND.KIEUFILE;
                        if (oDon != null)
                        { oVBTD.TENVUVIEC = oDon.TENVUVIEC; }
                        oVBTD.TOAANID = ToaAnID;
                        dkk.SaveChanges();
                    }
                    else
                    {
                        if (oDon != null)
                        { oVBTD.TENVUVIEC = oDon.TENVUVIEC; }
                        oVBTD.TOAANID = ToaAnID;
                        oVBTD.VUVIECID = DONID;
                        oVBTD.MALOAIVUVIEC = ENUM_LOAIAN.AN_DANSU;
                        oVBTD.DUONGSUID = DuongsuID;
                        oVBTD.TENVANBAN = ddlBieumau.SelectedItem.Text;
                        oVBTD.NGAYGUI = DateTime.Now;
                        oVBTD.NGAYNHANTONGDAT = DateTime.Now;
                        if (oF != null)
                        {
                            oVBTD.BIEUMAUID = oF.ID;
                            oVBTD.NOIDUNGFILE = oF.NOIDUNG;
                            oVBTD.TENFILE = oF.TENFILE;
                            oVBTD.LOAIFILE = oF.KIEUFILE;
                        }
                        dkk.DONKK_DON_VBTONGDAT.Add(oVBTD);
                        dkk.SaveChanges();
                    }
                }

            }
        }
        private void SaveAnHC(decimal ToaAnID, decimal DONID, decimal TongDatID)
        {
            AHC_FILE oF = new AHC_FILE();
            AHC_TONGDAT oND = dt.AHC_TONGDAT.Where(x => x.ID == TongDatID).FirstOrDefault();
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            oND.DONID = DONID;
            oND.TOAANID = ToaAnID;
            oF = dt.AHC_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
            if (oF != null)
            {
                if (oF.TENFILE == null && trTructuyen.Visible)
                {
                    if (hddFilePath.Value == "")
                    {
                        lbthongbao.Text = "Biểu mẫu chưa được đính kèm file để tống đạt trực tuyến !";
                        return;
                    }
                    else
                    {
                        try
                        {
                            string strFilePath = "";
                            if (chkKySo.Checked)
                            {
                                string[] arr = hddFilePath.Value.Split('/');
                                strFilePath = arr[arr.Length - 1];
                                strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                            }
                            else
                                strFilePath = hddFilePath.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo objf = new FileInfo(strFilePath);
                                long numBytes = objf.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oF.NOIDUNG = buff;
                                oF.TENFILE = Cls_Comon.ChuyenTenFileUpload(objf.Name);
                                oF.KIEUFILE = objf.Extension;
                                dt.SaveChanges();
                            }
                            File.Delete(strFilePath);
                        }
                        catch (Exception ex) { lbthongbao.Text = ex.Message; }
                    }
                }
                oND.FILEID = oF.ID;
                oND.BIEUMAUID = oF.BIEUMAUID;
            }
            dt.SaveChanges();

            if (trVKS.Visible)
            {
                oND.IS_TD_VKS = Convert.ToDecimal(rdbIsVKS.SelectedValue);
                if (rdbIsVKS.SelectedValue == "1")
                {
                    if (txtVKS_Ngaygui.Visible)
                        oND.IS_TD_VKS_NGAY = txtVKS_Ngaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_Ngaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (txtVKS_NgayNhan.Visible)
                        oND.NGAYNHANTONGDAT = txtVKS_NgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }
            }
            //Lưu thông tin tống đạt tới đương sự trực tiếp
            if (trDuongsu.Visible)
            {
                decimal TongdatID = oND.ID;
                foreach (DataGridItem Item in dgTructiep.Items)
                {
                    CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                    //DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");
                    //decimal vHinhthucgui = Convert.ToDecimal(ddlHinhthucgui.SelectedValue);

                    decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                    AHC_TONGDAT_DOITUONG oTD = dt.AHC_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).FirstOrDefault();
                    //oTD.TONGDATID = TongdatID;
                    //oTD.DUONGSUID = DuongsuID;
                    //oTD.MATUCACH = Item.Cells[1].Text;
                    //oTD.HINHTHUCGUI = vHinhthucgui;
                    //oTD.TRANGTHAI = 1;
                    if (chkIsSend.Checked)
                    {
                        oTD.NGAYGUI = txtNgaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oTD.NGAYNHANTONGDAT = txtNgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        // Nếu tống đạt văn bản
                        // là bản án sơ thẩm thì sẽ lưu AHC_SOTHAM_BANAN_ANPHI
                        if (ddlBieumau.SelectedItem.Text.Contains("22-HC") || ddlBieumau.SelectedItem.Text.Contains("Bản án hành chính sơ thẩm") || lstTenBM.Text.Contains("Bản án hành chính sơ thẩm"))
                        {
                            Update_AHC_SOTHAM_BANAN_ANPHI(DONID, DuongsuID, oTD.NGAYNHANTONGDAT);
                        }
                    }
                    else
                    {
                        oTD.NGAYGUI = (DateTime?)null;
                        oTD.NGAYNHANTONGDAT = (DateTime?)null;
                    }
                    dt.SaveChanges();
                }
            }
            //Lưu thông tin tống đạt tới đương sự trực tuyến
            if (trTructuyen.Visible)
            {
                decimal TongdatID = oND.ID;
                foreach (DataGridItem Item in dgTructuyen.Items)
                {
                    decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                    AHC_TONGDAT_DOITUONG oTD = dt.AHC_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).FirstOrDefault();
                    if (oTD.NGAYGUI == null || ((DateTime)oTD.NGAYGUI).ToString("dd/MM/yyyy") == "01/01/0001")
                    {
                        oTD.NGAYGUI = DateTime.Now;
                        oTD.NGAYNHANTONGDAT = DateTime.Now;
                        dt.SaveChanges();
                        ///insert vào bảng DVCQG_THANH_TOAN
                        DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                        obj.DVCQG_THANH_TOAN_UP_TONGDAT(oND.ID, DuongsuID, "6");
                    }
                    // Nếu tống đạt văn bản
                    // là bản án sơ thẩm thì sẽ lưu AHC_SOTHAM_BANAN_ANPHI
                    if (ddlBieumau.SelectedItem.Text.Contains("22-HC") || ddlBieumau.SelectedItem.Text.Contains("Bản án hành chính sơ thẩm") || lstTenBM.Text.Contains("Bản án hành chính sơ thẩm"))
                    {
                        Update_AHC_SOTHAM_BANAN_ANPHI(DONID, DuongsuID, oTD.NGAYNHANTONGDAT);
                    }
                    //Gửi sang hệ thống ĐKK
                    List<DONKK_DON_VBTONGDAT> lstDKK = null;
                    if (oF != null)
                    {
                        lstDKK = dkk.DONKK_DON_VBTONGDAT.Where(x => x.BIEUMAUID == oF.ID && x.MALOAIVUVIEC == ENUM_LOAIAN.AN_HANHCHINH && x.VUVIECID == DONID && x.DUONGSUID == DuongsuID).ToList();
                    }
                    DONKK_DON_VBTONGDAT oVBTD = new DONKK_DON_VBTONGDAT();
                    AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    if (lstDKK != null && lstDKK.Count > 0)
                    {
                        oVBTD = lstDKK[0];
                        oVBTD.NOIDUNGFILE = oND.NOIDUNGFILE;
                        oVBTD.TENFILE = oND.TENFILE;
                        oVBTD.LOAIFILE = oND.KIEUFILE;
                        if (oDon != null)
                        { oVBTD.TENVUVIEC = oDon.TENVUVIEC; }
                        oVBTD.TOAANID = ToaAnID;
                        dkk.SaveChanges();
                    }
                    else
                    {
                        if (oDon != null)
                        { oVBTD.TENVUVIEC = oDon.TENVUVIEC; }
                        oVBTD.TOAANID = ToaAnID;
                        oVBTD.VUVIECID = DONID;
                        oVBTD.MALOAIVUVIEC = ENUM_LOAIAN.AN_HANHCHINH;
                        oVBTD.DUONGSUID = DuongsuID;
                        oVBTD.TENVANBAN = ddlBieumau.SelectedItem.Text;
                        oVBTD.NGAYGUI = DateTime.Now;
                        oVBTD.NGAYNHANTONGDAT = DateTime.Now;
                        if (oF != null)
                        {
                            oVBTD.BIEUMAUID = oF.ID;
                            oVBTD.NOIDUNGFILE = oF.NOIDUNG;
                            oVBTD.TENFILE = oF.TENFILE;
                            oVBTD.LOAIFILE = oF.KIEUFILE;
                        }
                        dkk.DONKK_DON_VBTONGDAT.Add(oVBTD);
                        dkk.SaveChanges();
                    }
                }
            }
        }
        private void SaveAnHN(decimal ToaAnID, decimal DONID, decimal TongDatID)
        {
            AHN_FILE oF = new AHN_FILE();
            AHN_TONGDAT oND = dt.AHN_TONGDAT.Where(x => x.ID == TongDatID).FirstOrDefault();
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            oND.DONID = DONID;
            oND.TOAANID = ToaAnID;
            oF = dt.AHN_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
            if (oF != null)
            {
                if (oF.TENFILE == null && trTructuyen.Visible)
                {
                    if (hddFilePath.Value == "")
                    {
                        lbthongbao.Text = "Biểu mẫu chưa được đính kèm file để tống đạt trực tuyến !";
                        return;
                    }
                    else
                    {
                        try
                        {
                            string strFilePath = "";
                            if (chkKySo.Checked)
                            {
                                string[] arr = hddFilePath.Value.Split('/');
                                strFilePath = arr[arr.Length - 1];
                                strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                            }
                            else
                                strFilePath = hddFilePath.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo objf = new FileInfo(strFilePath);
                                long numBytes = objf.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oF.NOIDUNG = buff;
                                oF.TENFILE = Cls_Comon.ChuyenTenFileUpload(objf.Name);
                                oF.KIEUFILE = objf.Extension;
                                dt.SaveChanges();
                            }
                            File.Delete(strFilePath);
                        }
                        catch (Exception ex) { lbthongbao.Text = ex.Message; }
                    }
                }
                oND.FILEID = oF.ID;
                oND.BIEUMAUID = oF.BIEUMAUID;
            }
            dt.SaveChanges();

            if (trVKS.Visible)
            {
                oND.IS_TD_VKS = Convert.ToDecimal(rdbIsVKS.SelectedValue);
                if (rdbIsVKS.SelectedValue == "1")
                {
                    if (txtVKS_Ngaygui.Visible)
                        oND.IS_TD_VKS_NGAY = txtVKS_Ngaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_Ngaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (txtVKS_NgayNhan.Visible)
                        oND.NGAYNHANTONGDAT = txtVKS_NgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }
            }
            //Lưu thông tin tống đạt tới đương sự trực tiếp
            if (trDuongsu.Visible)
            {
                decimal TongdatID = oND.ID;
                foreach (DataGridItem Item in dgTructiep.Items)
                {
                    CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                    //DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");
                    //decimal vHinhthucgui = Convert.ToDecimal(ddlHinhthucgui.SelectedValue);

                    decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                    AHN_TONGDAT_DOITUONG oTD = dt.AHN_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).FirstOrDefault();
                    //oTD.TONGDATID = TongdatID;
                    //oTD.DUONGSUID = DuongsuID;
                    //oTD.MATUCACH = Item.Cells[1].Text;
                    //oTD.HINHTHUCGUI = vHinhthucgui;
                    //oTD.TRANGTHAI = 1;
                    if (chkIsSend.Checked)
                    {
                        oTD.NGAYGUI = txtNgaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oTD.NGAYNHANTONGDAT = txtNgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        // Nếu tống đạt văn bản
                        // là bản án sơ thẩm thì sẽ lưu AHN_SOTHAM_BANAN_ANPHI
                        if (ddlBieumau.SelectedItem.Text.Contains("52-DS") || ddlBieumau.SelectedItem.Text.Contains("Bản án dân sự sơ thẩm") || lstTenBM.Text.Contains("Bản án dân sự sơ thẩm"))
                        {
                            Update_AHN_SOTHAM_BANAN_ANPHI(DONID, DuongsuID, oTD.NGAYNHANTONGDAT);
                        }
                    }
                    else
                    {
                        oTD.NGAYGUI = (DateTime?)null;
                        oTD.NGAYNHANTONGDAT = (DateTime?)null;
                    }
                    dt.SaveChanges();
                }
            }
            //Lưu thông tin tống đạt tới đương sự trực tuyến
            if (trTructuyen.Visible)
            {
                decimal TongdatID = oND.ID;
                foreach (DataGridItem Item in dgTructuyen.Items)
                {
                    decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                    AHN_TONGDAT_DOITUONG oTD = dt.AHN_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).FirstOrDefault();
                    if (oTD.NGAYGUI == null || ((DateTime)oTD.NGAYGUI).ToString("dd/MM/yyyy") == "01/01/0001")
                    {
                        oTD.NGAYGUI = DateTime.Now;
                        oTD.NGAYNHANTONGDAT = DateTime.Now;
                        dt.SaveChanges();
                        ///insert vào bảng DVCQG_THANH_TOAN
                        DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                        obj.DVCQG_THANH_TOAN_UP_TONGDAT(oND.ID, DuongsuID, "3");
                    }
                    // Nếu tống đạt văn bản
                    // là bản án sơ thẩm thì sẽ lưu AHN_SOTHAM_BANAN_ANPHI
                    if (ddlBieumau.SelectedItem.Text.Contains("52-DS") || ddlBieumau.SelectedItem.Text.Contains("Bản án dân sự sơ thẩm") || lstTenBM.Text.Contains("Bản án dân sự sơ thẩm"))
                    {
                        Update_AHN_SOTHAM_BANAN_ANPHI(DONID, DuongsuID, oTD.NGAYNHANTONGDAT);
                    }
                    //Gửi sang hệ thống ĐKK
                    List<DONKK_DON_VBTONGDAT> lstDKK = null;
                    if (oF != null)
                    {
                        lstDKK = dkk.DONKK_DON_VBTONGDAT.Where(x => x.BIEUMAUID == oF.ID && x.MALOAIVUVIEC == ENUM_LOAIAN.AN_HONNHAN_GIADINH && x.VUVIECID == DONID && x.DUONGSUID == DuongsuID).ToList();
                    }
                    DONKK_DON_VBTONGDAT oVBTD = new DONKK_DON_VBTONGDAT();
                    AHN_DON oDon = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    if (lstDKK != null && lstDKK.Count > 0)
                    {
                        oVBTD = lstDKK[0];
                        oVBTD.NOIDUNGFILE = oND.NOIDUNGFILE;
                        oVBTD.TENFILE = oND.TENFILE;
                        oVBTD.LOAIFILE = oND.KIEUFILE;
                        if (oDon != null)
                        { oVBTD.TENVUVIEC = oDon.TENVUVIEC; }
                        oVBTD.TOAANID = ToaAnID;
                        dkk.SaveChanges();
                    }
                    else
                    {
                        if (oDon != null)
                        { oVBTD.TENVUVIEC = oDon.TENVUVIEC; }
                        oVBTD.TOAANID = ToaAnID;
                        oVBTD.VUVIECID = DONID;
                        oVBTD.MALOAIVUVIEC = ENUM_LOAIAN.AN_HONNHAN_GIADINH;
                        oVBTD.DUONGSUID = DuongsuID;
                        oVBTD.TENVANBAN = ddlBieumau.SelectedItem.Text;
                        oVBTD.NGAYGUI = DateTime.Now;
                        oVBTD.NGAYNHANTONGDAT = DateTime.Now;
                        if (oF != null)
                        {
                            oVBTD.BIEUMAUID = oF.ID;
                            oVBTD.NOIDUNGFILE = oF.NOIDUNG;
                            oVBTD.TENFILE = oF.TENFILE;
                            oVBTD.LOAIFILE = oF.KIEUFILE;
                        }
                        dkk.DONKK_DON_VBTONGDAT.Add(oVBTD);
                        dkk.SaveChanges();
                    }
                }
            }
        }
        private void SaveAnLD(decimal ToaAnID, decimal DONID, decimal TongDatID)
        {
            ALD_FILE oF = new ALD_FILE();
            ALD_TONGDAT oND = dt.ALD_TONGDAT.Where(x => x.ID == TongDatID).FirstOrDefault();
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            oND.DONID = DONID;
            oND.TOAANID = ToaAnID;
            oF = dt.ALD_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
            if (oF != null)
            {
                if (oF.TENFILE == null && trTructuyen.Visible)
                {
                    if (hddFilePath.Value == "")
                    {
                        lbthongbao.Text = "Biểu mẫu chưa được đính kèm file để tống đạt trực tuyến !";
                        return;
                    }
                    else
                    {
                        try
                        {
                            string strFilePath = "";
                            if (chkKySo.Checked)
                            {
                                string[] arr = hddFilePath.Value.Split('/');
                                strFilePath = arr[arr.Length - 1];
                                strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                            }
                            else
                                strFilePath = hddFilePath.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo objf = new FileInfo(strFilePath);
                                long numBytes = objf.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oF.NOIDUNG = buff;
                                oF.TENFILE = Cls_Comon.ChuyenTenFileUpload(objf.Name);
                                oF.KIEUFILE = objf.Extension;
                                dt.SaveChanges();
                            }
                            File.Delete(strFilePath);
                        }
                        catch (Exception ex) { lbthongbao.Text = ex.Message; }
                    }
                }
                oND.FILEID = oF.ID;
                oND.BIEUMAUID = oF.BIEUMAUID;
            }
            dt.SaveChanges();

            if (trVKS.Visible)
            {
                oND.IS_TD_VKS = Convert.ToDecimal(rdbIsVKS.SelectedValue);
                if (rdbIsVKS.SelectedValue == "1")
                {
                    if (txtVKS_Ngaygui.Visible)
                        oND.IS_TD_VKS_NGAY = txtVKS_Ngaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_Ngaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (txtVKS_NgayNhan.Visible)
                        oND.NGAYNHANTONGDAT = txtVKS_NgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }
            }
            //Lưu thông tin tống đạt tới đương sự trực tiếp
            if (trDuongsu.Visible)
            {
                decimal TongdatID = oND.ID;
                foreach (DataGridItem Item in dgTructiep.Items)
                {
                    CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                    //DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");
                    //decimal vHinhthucgui = Convert.ToDecimal(ddlHinhthucgui.SelectedValue);

                    decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                    ALD_TONGDAT_DOITUONG oTD = dt.ALD_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).FirstOrDefault();
                    //oTD.TONGDATID = TongdatID;
                    //oTD.DUONGSUID = DuongsuID;
                    //oTD.MATUCACH = Item.Cells[1].Text;
                    //oTD.HINHTHUCGUI = vHinhthucgui;
                    //oTD.TRANGTHAI = 1;
                    if (chkIsSend.Checked)
                    {
                        oTD.NGAYGUI = txtNgaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oTD.NGAYNHANTONGDAT = txtNgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        // Nếu tống đạt văn bản
                        // là bản án sơ thẩm thì sẽ lưu ALD_SOTHAM_BANAN_ANPHI
                        if (ddlBieumau.SelectedItem.Text.Contains("52-DS") || ddlBieumau.SelectedItem.Text.Contains("Bản án dân sự sơ thẩm") || lstTenBM.Text.Contains("Bản án dân sự sơ thẩm"))
                        {
                            Update_ALD_SOTHAM_BANAN_ANPHI(DONID, DuongsuID, oTD.NGAYNHANTONGDAT);
                        }
                    }
                    else
                    {
                        oTD.NGAYGUI = (DateTime?)null;
                        oTD.NGAYNHANTONGDAT = (DateTime?)null;
                    }
                    dt.SaveChanges();
                }
            }
            //Lưu thông tin tống đạt tới đương sự trực tuyến
            if (trTructuyen.Visible)
            {
                decimal TongdatID = oND.ID;
                foreach (DataGridItem Item in dgTructuyen.Items)
                {
                    decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                    ALD_TONGDAT_DOITUONG oTD = dt.ALD_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).FirstOrDefault();
                    if (oTD.NGAYGUI == null || ((DateTime)oTD.NGAYGUI).ToString("dd/MM/yyyy") == "01/01/0001")
                    {
                        oTD.NGAYGUI = DateTime.Now;
                        oTD.NGAYNHANTONGDAT = DateTime.Now;
                        dt.SaveChanges();
                        ///insert vào bảng DVCQG_THANH_TOAN
                        DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                        obj.DVCQG_THANH_TOAN_UP_TONGDAT(oND.ID, DuongsuID, "5");
                    }

                    dt.SaveChanges();
                    // Nếu tống đạt văn bản
                    // là bản án sơ thẩm thì sẽ lưu ALD_SOTHAM_BANAN_ANPHI
                    if (ddlBieumau.SelectedItem.Text.Contains("52-DS") || ddlBieumau.SelectedItem.Text.Contains("Bản án dân sự sơ thẩm") || lstTenBM.Text.Contains("Bản án dân sự sơ thẩm"))
                    {
                        Update_ALD_SOTHAM_BANAN_ANPHI(DONID, DuongsuID, oTD.NGAYNHANTONGDAT);
                    }
                    //Gửi sang hệ thống ĐKK
                    List<DONKK_DON_VBTONGDAT> lstDKK = null;
                    if (oF != null)
                    {
                        lstDKK = dkk.DONKK_DON_VBTONGDAT.Where(x => x.BIEUMAUID == oF.ID && x.MALOAIVUVIEC == ENUM_LOAIAN.AN_LAODONG && x.VUVIECID == DONID && x.DUONGSUID == DuongsuID).ToList();
                    }
                    DONKK_DON_VBTONGDAT oVBTD = new DONKK_DON_VBTONGDAT();
                    ALD_DON oDon = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    if (lstDKK != null && lstDKK.Count > 0)
                    {
                        oVBTD = lstDKK[0];
                        oVBTD.NOIDUNGFILE = oND.NOIDUNGFILE;
                        oVBTD.TENFILE = oND.TENFILE;
                        oVBTD.LOAIFILE = oND.KIEUFILE;
                        if (oDon != null)
                        { oVBTD.TENVUVIEC = oDon.TENVUVIEC; }
                        oVBTD.TOAANID = ToaAnID;
                        dkk.SaveChanges();
                    }
                    else
                    {
                        if (oDon != null)
                        { oVBTD.TENVUVIEC = oDon.TENVUVIEC; }
                        oVBTD.TOAANID = ToaAnID;
                        oVBTD.VUVIECID = DONID;
                        oVBTD.MALOAIVUVIEC = ENUM_LOAIAN.AN_LAODONG;
                        oVBTD.DUONGSUID = DuongsuID;
                        oVBTD.TENVANBAN = ddlBieumau.SelectedItem.Text;
                        oVBTD.NGAYGUI = DateTime.Now;
                        oVBTD.NGAYNHANTONGDAT = DateTime.Now;
                        if (oF != null)
                        {
                            oVBTD.BIEUMAUID = oF.ID;
                            oVBTD.NOIDUNGFILE = oF.NOIDUNG;
                            oVBTD.TENFILE = oF.TENFILE;
                            oVBTD.LOAIFILE = oF.KIEUFILE;
                        }
                        dkk.DONKK_DON_VBTONGDAT.Add(oVBTD);
                        dkk.SaveChanges();
                    }
                }
            }
        }
        private void SaveAnKT(decimal ToaAnID, decimal DONID, decimal TongDatID)
        {
            AKT_FILE oF = new AKT_FILE();
            AKT_TONGDAT oND = dt.AKT_TONGDAT.Where(x => x.ID == TongDatID).FirstOrDefault();
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            oND.DONID = DONID;
            oND.TOAANID = ToaAnID;
            oF = dt.AKT_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
            if (oF != null)
            {
                if (oF.TENFILE == null && trTructuyen.Visible)
                {
                    if (hddFilePath.Value == "")
                    {
                        lbthongbao.Text = "Biểu mẫu chưa được đính kèm file để tống đạt trực tuyến !";
                        return;
                    }
                    else
                    {
                        try
                        {
                            string strFilePath = "";
                            if (chkKySo.Checked)
                            {
                                string[] arr = hddFilePath.Value.Split('/');
                                strFilePath = arr[arr.Length - 1];
                                strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                            }
                            else
                                strFilePath = hddFilePath.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo objf = new FileInfo(strFilePath);
                                long numBytes = objf.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oF.NOIDUNG = buff;
                                oF.TENFILE = Cls_Comon.ChuyenTenFileUpload(objf.Name);
                                oF.KIEUFILE = objf.Extension;
                                dt.SaveChanges();
                            }
                            File.Delete(strFilePath);
                        }
                        catch (Exception ex) { lbthongbao.Text = ex.Message; }
                    }
                }
                oND.FILEID = oF.ID;
                oND.BIEUMAUID = oF.BIEUMAUID;
            }
            dt.SaveChanges();

            if (trVKS.Visible)
            {
                oND.IS_TD_VKS = Convert.ToDecimal(rdbIsVKS.SelectedValue);
                if (rdbIsVKS.SelectedValue == "1")
                {
                    if (txtVKS_Ngaygui.Visible)
                        oND.IS_TD_VKS_NGAY = txtVKS_Ngaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_Ngaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (txtVKS_NgayNhan.Visible)
                        oND.NGAYNHANTONGDAT = txtVKS_NgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }
            }
            //Lưu thông tin tống đạt tới đương sự trực tiếp
            if (trDuongsu.Visible)
            {
                decimal TongdatID = oND.ID;
                foreach (DataGridItem Item in dgTructiep.Items)
                {
                    CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                    //DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");
                    //decimal vHinhthucgui = Convert.ToDecimal(ddlHinhthucgui.SelectedValue);

                    decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);

                    AKT_TONGDAT_DOITUONG oTD = dt.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).FirstOrDefault();
                    //oTD.TONGDATID = TongdatID;
                    //oTD.DUONGSUID = DuongsuID;
                    //oTD.MATUCACH = Item.Cells[1].Text;
                    //oTD.HINHTHUCGUI = vHinhthucgui;
                    //oTD.TRANGTHAI = 1;
                    if (chkIsSend.Checked)
                    {
                        oTD.NGAYGUI = txtNgaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oTD.NGAYNHANTONGDAT = txtNgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        // Nếu tống đạt văn bản
                        // là bản án sơ thẩm thì sẽ lưu AKT_SOTHAM_BANAN_ANPHI
                        if (ddlBieumau.SelectedItem.Text.Contains("52-DS") || ddlBieumau.SelectedItem.Text.Contains("Bản án dân sự sơ thẩm") || lstTenBM.Text.Contains("Bản án dân sự sơ thẩm"))
                        {
                            Update_AKT_SOTHAM_BANAN_ANPHI(DONID, DuongsuID, oTD.NGAYNHANTONGDAT);
                        }
                    }
                    else
                    {
                        oTD.NGAYGUI = (DateTime?)null;
                        oTD.NGAYNHANTONGDAT = (DateTime?)null;
                    }
                    dt.SaveChanges();
                }
            }
            //Lưu thông tin tống đạt tới đương sự trực tuyến
            if (trTructuyen.Visible)
            {
                decimal TongdatID = oND.ID;
                foreach (DataGridItem Item in dgTructuyen.Items)
                {
                    decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                    AKT_TONGDAT_DOITUONG oTD = dt.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).FirstOrDefault();
                    if (oTD.NGAYGUI == null || ((DateTime)oTD.NGAYGUI).ToString("dd/MM/yyyy") == "01/01/0001")
                    {
                        oTD.NGAYGUI = DateTime.Now;
                        oTD.NGAYNHANTONGDAT = DateTime.Now;
                        dt.SaveChanges();
                        ///insert vào bảng DVCQG_THANH_TOAN
                        DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                        obj.DVCQG_THANH_TOAN_UP_TONGDAT(oND.ID, DuongsuID, "4");
                    }
                    // Nếu tống đạt văn bản
                    // là bản án sơ thẩm thì sẽ lưu AKT_SOTHAM_BANAN_ANPHI
                    if (ddlBieumau.SelectedItem.Text.Contains("52-DS") || ddlBieumau.SelectedItem.Text.Contains("Bản án dân sự sơ thẩm") || lstTenBM.Text.Contains("Bản án dân sự sơ thẩm"))
                    {
                        Update_AKT_SOTHAM_BANAN_ANPHI(DONID, DuongsuID, oTD.NGAYNHANTONGDAT);
                    }
                    //Gửi sang hệ thống ĐKK
                    List<DONKK_DON_VBTONGDAT> lstDKK = null;
                    if (oF != null)
                    {
                        lstDKK = dkk.DONKK_DON_VBTONGDAT.Where(x => x.BIEUMAUID == oF.ID && x.MALOAIVUVIEC == ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI && x.VUVIECID == DONID && x.DUONGSUID == DuongsuID).ToList();
                    }
                    DONKK_DON_VBTONGDAT oVBTD = new DONKK_DON_VBTONGDAT();
                    AKT_DON oDon = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    if (lstDKK != null && lstDKK.Count > 0)
                    {
                        oVBTD = lstDKK[0];
                        oVBTD.NOIDUNGFILE = oND.NOIDUNGFILE;
                        oVBTD.TENFILE = oND.TENFILE;
                        oVBTD.LOAIFILE = oND.KIEUFILE;
                        if (oDon != null)
                        { oVBTD.TENVUVIEC = oDon.TENVUVIEC; }
                        oVBTD.TOAANID = ToaAnID;
                        dkk.SaveChanges();
                    }
                    else
                    {
                        if (oDon != null)
                        { oVBTD.TENVUVIEC = oDon.TENVUVIEC; }
                        oVBTD.TOAANID = ToaAnID;
                        oVBTD.VUVIECID = DONID;
                        oVBTD.MALOAIVUVIEC = ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI;
                        oVBTD.DUONGSUID = DuongsuID;
                        oVBTD.TENVANBAN = ddlBieumau.SelectedItem.Text;
                        oVBTD.NGAYGUI = DateTime.Now;
                        oVBTD.NGAYNHANTONGDAT = DateTime.Now;
                        if (oF != null)
                        {
                            oVBTD.BIEUMAUID = oF.ID;
                            oVBTD.NOIDUNGFILE = oF.NOIDUNG;
                            oVBTD.TENFILE = oF.TENFILE;
                            oVBTD.LOAIFILE = oF.KIEUFILE;
                        }
                        dkk.DONKK_DON_VBTONGDAT.Add(oVBTD);
                        dkk.SaveChanges();
                    }
                }
            }
        }
        private void SaveAnPS(decimal ToaAnID, decimal DONID, decimal TongDatID) { }

        public void LoadGrid()
        {
            TONGDAT_BL oBL = new TONGDAT_BL();
            DataTable oDT = oBL.GET_VANTHU_TONGDAT_GETLIST(VuAnID, CurrDonViID, vLoaian, vBieumauid);
            #region "Xác định số lượng trang"
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            #endregion

            dgList.DataSource = oDT;
            dgList.DataBind();

        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
            lbthongbao.Text = "";
        }
        public void xoa(decimal id)
        {
            //DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
            //decimal _VALUE = 0;
            //obj.DVCQG_TT_REMOVE_TONGDAT(id, "2", ref _VALUE);
            //if (_VALUE == 1)
            //{
            //    List<ADS_TONGDAT_DOITUONG> lst = dt.ADS_TONGDAT_DOITUONG.Where(x => x.TONGDATID == id).ToList();
            //    if (lst.Count > 0)
            //    {
            //        dt.ADS_TONGDAT_DOITUONG.RemoveRange(lst);
            //    }
            //    ADS_TONGDAT oND = dt.ADS_TONGDAT.Where(x => x.ID == id).FirstOrDefault();
            //    if (oND != null)
            //    {
            //        dt.ADS_TONGDAT.Remove(oND);
            //    }
            //    dt.SaveChanges();
            //    dgList.CurrentPageIndex = 0;
            //    LoadGrid();
            //    ResetControls();
            //    lbthongbao.Text = "Xóa thành công!";
            //}
            //else
            //{
            //    lbthongbao.Text = "Đã phát sinh giao dịch thanh toán, bạn không được Xóa!";
            //}
        }
        public void loadedit(decimal ID)
        {
            //cmdLammoi.Visible = true;
            bool IsShowVKS = false;
            trThemFile.Visible = false;
            decimal BIEUMAUID = 0, IS_TD_VKS = 0, FILEID = 0;
            DateTime? IS_TD_VKS_NGAY = null;
            //ADS_TONGDAT oND = dt.ADS_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
            if (vLoaian == 1)
            {
                AHS_TONGDAT oND = dt.AHS_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddid.Value = oND.ID.ToString();
                    BIEUMAUID = oND.BIEUMAUID + "" == "" ? 0 : (decimal)oND.BIEUMAUID;
                    IS_TD_VKS = oND.IS_TD_VKS + "" == "" ? 0 : (decimal)oND.IS_TD_VKS;
                    IS_TD_VKS_NGAY = oND.IS_TD_VKS_NGAY;
                    FILEID = oND.FILEID + "" == "" ? 0 : (decimal)oND.FILEID;

                    if (IS_TD_VKS == 1)
                    {
                        IsShowVKS = true;
                        txtVKS_Ngaygui.Text = IS_TD_VKS_NGAY + "" == "" ? DateTime.Now.ToString("dd/MM/yyyy", cul) : ((DateTime)IS_TD_VKS_NGAY).ToString("dd/MM/yyyy", cul);
                        txtVKS_NgayNhan.Text = oND.NGAYNHANTONGDAT + "" == "" ? "" : ((DateTime)oND.NGAYNHANTONGDAT).ToString("dd/MM/yyyy", cul);
                    }
                    else
                    {
                        txtVKS_Ngaygui.Text = txtVKS_NgayNhan.Text = "";
                    }
                }

            }
            else if (vLoaian == 2)
            {
                ADS_TONGDAT oND = dt.ADS_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddid.Value = oND.ID.ToString();
                    BIEUMAUID = oND.BIEUMAUID + "" == "" ? 0 : (decimal)oND.BIEUMAUID;
                    IS_TD_VKS = oND.IS_TD_VKS + "" == "" ? 0 : (decimal)oND.IS_TD_VKS;
                    IS_TD_VKS_NGAY = oND.IS_TD_VKS_NGAY;
                    FILEID = oND.FILEID + "" == "" ? 0 : (decimal)oND.FILEID;
                    if (IS_TD_VKS == 1)
                    {
                        IsShowVKS = true;
                        txtVKS_Ngaygui.Text = IS_TD_VKS_NGAY + "" == "" ? DateTime.Now.ToString("dd/MM/yyyy", cul) : ((DateTime)IS_TD_VKS_NGAY).ToString("dd/MM/yyyy", cul);
                        txtVKS_NgayNhan.Text = oND.NGAYNHANTONGDAT + "" == "" ? "" : ((DateTime)oND.NGAYNHANTONGDAT).ToString("dd/MM/yyyy", cul);
                    }
                    else
                    {
                        txtVKS_Ngaygui.Text = txtVKS_NgayNhan.Text = "";
                    }
                }

            }
            else if (vLoaian == 3)
            {
                AHN_TONGDAT oND = dt.AHN_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddid.Value = oND.ID.ToString();
                    BIEUMAUID = oND.BIEUMAUID + "" == "" ? 0 : (decimal)oND.BIEUMAUID;
                    IS_TD_VKS = oND.IS_TD_VKS + "" == "" ? 0 : (decimal)oND.IS_TD_VKS;
                    IS_TD_VKS_NGAY = oND.IS_TD_VKS_NGAY;
                    FILEID = oND.FILEID + "" == "" ? 0 : (decimal)oND.FILEID;
                    if (IS_TD_VKS == 1)
                    {
                        IsShowVKS = true;
                        txtVKS_Ngaygui.Text = IS_TD_VKS_NGAY + "" == "" ? DateTime.Now.ToString("dd/MM/yyyy", cul) : ((DateTime)IS_TD_VKS_NGAY).ToString("dd/MM/yyyy", cul);
                        txtVKS_NgayNhan.Text = oND.NGAYNHANTONGDAT + "" == "" ? "" : ((DateTime)oND.NGAYNHANTONGDAT).ToString("dd/MM/yyyy", cul);
                    }
                    else
                    {
                        txtVKS_Ngaygui.Text = txtVKS_NgayNhan.Text = "";
                    }
                }
            }
            else if (vLoaian == 4)
            {
                AKT_TONGDAT oND = dt.AKT_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddid.Value = oND.ID.ToString();
                    BIEUMAUID = oND.BIEUMAUID + "" == "" ? 0 : (decimal)oND.BIEUMAUID;
                    IS_TD_VKS = oND.IS_TD_VKS + "" == "" ? 0 : (decimal)oND.IS_TD_VKS;
                    IS_TD_VKS_NGAY = oND.IS_TD_VKS_NGAY;
                    FILEID = oND.FILEID + "" == "" ? 0 : (decimal)oND.FILEID;
                    if (IS_TD_VKS == 1)
                    {
                        IsShowVKS = true;
                        txtVKS_Ngaygui.Text = IS_TD_VKS_NGAY + "" == "" ? DateTime.Now.ToString("dd/MM/yyyy", cul) : ((DateTime)IS_TD_VKS_NGAY).ToString("dd/MM/yyyy", cul);
                        txtVKS_NgayNhan.Text = oND.NGAYNHANTONGDAT + "" == "" ? "" : ((DateTime)oND.NGAYNHANTONGDAT).ToString("dd/MM/yyyy", cul);
                    }
                    else
                    {
                        txtVKS_Ngaygui.Text = txtVKS_NgayNhan.Text = "";
                    }
                }
            }
            else if (vLoaian == 5)
            {
                ALD_TONGDAT oND = dt.ALD_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddid.Value = oND.ID.ToString();
                    BIEUMAUID = oND.BIEUMAUID + "" == "" ? 0 : (decimal)oND.BIEUMAUID;
                    IS_TD_VKS = oND.IS_TD_VKS + "" == "" ? 0 : (decimal)oND.IS_TD_VKS;
                    IS_TD_VKS_NGAY = oND.IS_TD_VKS_NGAY;
                    FILEID = oND.FILEID + "" == "" ? 0 : (decimal)oND.FILEID;
                    if (IS_TD_VKS == 1)
                    {
                        IsShowVKS = true;
                        txtVKS_Ngaygui.Text = IS_TD_VKS_NGAY + "" == "" ? DateTime.Now.ToString("dd/MM/yyyy", cul) : ((DateTime)IS_TD_VKS_NGAY).ToString("dd/MM/yyyy", cul);
                        txtVKS_NgayNhan.Text = oND.NGAYNHANTONGDAT + "" == "" ? "" : ((DateTime)oND.NGAYNHANTONGDAT).ToString("dd/MM/yyyy", cul);
                    }
                    else
                    {
                        txtVKS_Ngaygui.Text = txtVKS_NgayNhan.Text = "";
                    }
                }
            }
            else if (vLoaian == 6)
            {
                AHC_TONGDAT oND = dt.AHC_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddid.Value = oND.ID.ToString();
                    BIEUMAUID = oND.BIEUMAUID + "" == "" ? 0 : (decimal)oND.BIEUMAUID;
                    IS_TD_VKS = oND.IS_TD_VKS + "" == "" ? 0 : (decimal)oND.IS_TD_VKS;
                    IS_TD_VKS_NGAY = oND.IS_TD_VKS_NGAY;
                    FILEID = oND.FILEID + "" == "" ? 0 : (decimal)oND.FILEID;
                    if (IS_TD_VKS == 1)
                    {
                        IsShowVKS = true;
                        txtVKS_Ngaygui.Text = IS_TD_VKS_NGAY + "" == "" ? DateTime.Now.ToString("dd/MM/yyyy", cul) : ((DateTime)IS_TD_VKS_NGAY).ToString("dd/MM/yyyy", cul);
                        txtVKS_NgayNhan.Text = oND.NGAYNHANTONGDAT + "" == "" ? "" : ((DateTime)oND.NGAYNHANTONGDAT).ToString("dd/MM/yyyy", cul);
                    }
                    else
                    {
                        txtVKS_Ngaygui.Text = txtVKS_NgayNhan.Text = "";
                    }
                }
            }

            ddlBieumau.Visible = false;
            DM_BIEUMAU oBM = dt.DM_BIEUMAU.Where(x => x.ID == BIEUMAUID).FirstOrDefault();
            if (oBM != null)
            {
                lstTenBM.Text = oBM.TENBM;
            }

            LoadDoituong(IsShowVKS, BIEUMAUID);
            if (FILEID > 0)
            {
                ADS_FILE oF = dt.ADS_FILE.Where(x => x.ID == FILEID).FirstOrDefault();
                if (oF != null)
                {
                    if (oF.TENFILE != null)
                    {
                        lbtDownload.Visible = true;
                        lbtDownload.Text = oF.TENFILE;
                    }
                    else
                        lbtDownload.Visible = false;
                }
                hddFile.Value = FILEID + "";
            }
            else
                lbtDownload.Visible = false;
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(ND_id);
                    ResetControls();
                    break;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, true);
                string VuAnID = Session[ENUM_LOAIAN.AN_DANSU] + "";
                decimal DONID = Convert.ToDecimal(VuAnID);
                if (vLoaian == 1)
                {
                    AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == DONID).FirstOrDefault();
                    if (oT != null)
                    {
                        if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && oT.TOAANID + "" == Session[ENUM_SESSION.SESSION_DONVIID] + "")
                        {
                            lblSua.Text = "Xem chi tiết";
                        }
                    }

                }
                else if (vLoaian == 2)
                {
                    ADS_DON oT = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    if (oT != null)
                    {
                        if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && oT.TOAANID + "" == Session[ENUM_SESSION.SESSION_DONVIID] + "")
                        {
                            lblSua.Text = "Xem chi tiết";
                        }
                    }
                }
                else if (vLoaian == 3)
                {
                    AHN_DON oT = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    if (oT != null)
                    {
                        if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && oT.TOAANID + "" == Session[ENUM_SESSION.SESSION_DONVIID] + "")
                        {
                            lblSua.Text = "Xem chi tiết";
                        }
                    }
                }
                else if (vLoaian == 4)
                {
                    AKT_DON oT = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    if (oT != null)
                    {
                        if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && oT.TOAANID + "" == Session[ENUM_SESSION.SESSION_DONVIID] + "")
                        {
                            lblSua.Text = "Xem chi tiết";
                        }
                    }
                }
                else if (vLoaian == 5)
                {
                    ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    if (oT != null)
                    {
                        if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && oT.TOAANID + "" == Session[ENUM_SESSION.SESSION_DONVIID] + "")
                        {
                            lblSua.Text = "Xem chi tiết";
                        }
                    }
                }
                else if (vLoaian == 6)
                {
                    AHC_DON oT = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    if (oT != null)
                    {
                        if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && oT.TOAANID + "" == Session[ENUM_SESSION.SESSION_DONVIID] + "")
                        {
                            lblSua.Text = "Xem chi tiết";
                        }
                    }
                }
            }
        }

        protected void dgTructiep_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                Label lblHinhthucgui = (Label)e.Item.FindControl("lblHinhthucgui");
                string vHINHTHUCGUI = e.Item.Cells[2].Text;
                if (vHINHTHUCGUI != null && vHINHTHUCGUI != "&nbsp;" && vHINHTHUCGUI == "0")
                    lblHinhthucgui.Text = "Trực tiếp";
                else if (vHINHTHUCGUI != null && vHINHTHUCGUI != "&nbsp;" && vHINHTHUCGUI == "2")
                    lblHinhthucgui.Text = "Bưu điện";
                else if (vHINHTHUCGUI != null && vHINHTHUCGUI != "&nbsp;" && vHINHTHUCGUI == "3")
                    lblHinhthucgui.Text = "Tự UTTP";
                else if (vHINHTHUCGUI != null && vHINHTHUCGUI != "&nbsp;" && vHINHTHUCGUI == "4")
                    lblHinhthucgui.Text = "Cấp trên UTTP";
                else if (vHINHTHUCGUI != null && vHINHTHUCGUI != "&nbsp;" && vHINHTHUCGUI == "5")
                    lblHinhthucgui.Text = "Niêm yết công khai";
                else
                    lblHinhthucgui.Text = "";
            }
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }
        #endregion

        private void LoadDoituong(bool IsShowVKS, decimal BieuMauID)
        {
            trVKS.Visible = trDuongsu.Visible = false;
            trDuongsu.Visible = false;
            decimal BMID = 0, IS_TD_DUONGSU = 0, IS_TD_VKS = 0, IS_TD_NGUYENDON = 0;
            BMID = BieuMauID;
           
            DM_BIEUMAU oBM = dt.DM_BIEUMAU.Where(x => x.ID == BMID).FirstOrDefault();
            if (oBM != null)
            {
                IS_TD_VKS = oBM.IS_TD_VKS + "" == "" ? 0 : (decimal)oBM.IS_TD_VKS;
                IS_TD_DUONGSU = oBM.IS_TD_DUONGSU + "" == "" ? 0 : (decimal)oBM.IS_TD_DUONGSU;
                IS_TD_NGUYENDON = oBM.IS_TD_NGUYENDON + "" == "" ? 0 : (decimal)oBM.IS_TD_NGUYENDON;
            }
            //if (IS_TD_VKS == 1)
            //{
            decimal objVKS = 0;
            if (oBM.LOAIAN == 1) {
                AHS_TONGDAT oND = dt.AHS_TONGDAT.Where(x => x.ID == vTongDatID).FirstOrDefault();
                if (oND != null)
                    objVKS = Convert.ToDecimal(oND.IS_TD_VKS);
            }
            else if (oBM.LOAIAN == 2) {
                ADS_TONGDAT oND = dt.ADS_TONGDAT.Where(x => x.ID == vTongDatID).FirstOrDefault();
                if (oND != null)
                    objVKS = Convert.ToDecimal(oND.IS_TD_VKS);
            }
            else if (oBM.LOAIAN == 3)
            {
                AHN_TONGDAT oND = dt.AHN_TONGDAT.Where(x => x.ID == vTongDatID).FirstOrDefault();
                if (oND != null)
                    objVKS = Convert.ToDecimal(oND.IS_TD_VKS);
            }
            else if (oBM.LOAIAN == 4)
            {
                AKT_TONGDAT oND = dt.AKT_TONGDAT.Where(x => x.ID == vTongDatID).FirstOrDefault();
                if (oND != null)
                    objVKS = Convert.ToDecimal(oND.IS_TD_VKS);
            }
            else if (oBM.LOAIAN == 5)
            {
                ALD_TONGDAT oND = dt.ALD_TONGDAT.Where(x => x.ID == vTongDatID).FirstOrDefault();
                if (oND != null)
                    objVKS = Convert.ToDecimal(oND.IS_TD_VKS);
            }
            else if (oBM.LOAIAN == 6)
            {
                AHC_TONGDAT oND = dt.AHC_TONGDAT.Where(x => x.ID == vTongDatID).FirstOrDefault();
                if (oND != null)
                    objVKS = Convert.ToDecimal(oND.IS_TD_VKS);
            }
                
            if (objVKS == 1)
            {
                trVKS.Visible = true;
                if (IsShowVKS)
                {
                    rdbIsVKS.SelectedValue = "1";
                    lblVKSNgaygui.Visible = txtVKS_Ngaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = true;
                }
                else
                {
                    rdbIsVKS.SelectedValue = "0";
                    lblVKSNgaygui.Visible = txtVKS_Ngaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = false;
                }
            }
            //}
            else
            {
                trVKS.Visible = false;
                rdbIsVKS.SelectedValue = "0";
                lblVKSNgaygui.Visible = txtVKS_Ngaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = false;
            }
            TONGDAT_BL oTD = new TONGDAT_BL();
            decimal DONID = Convert.ToDecimal(VuAnID);
            decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable oDTDS = null;
            if (hddIsTructuyen.Value == "1")
            {
                trTructuyen.Visible = true;
            }
            if (IS_TD_DUONGSU == 1)
            {
                   oDTDS = oTD.TONGDAT_DOITUONG_GETBY(DONID,vLoaian, TOAANID, BMID, 0);
                   trDuongsu.Visible = true;
            }
            else if (IS_TD_NGUYENDON == 1 && IS_TD_DUONGSU != 1)
            {
                oDTDS = oTD.TONGDAT_DOITUONG_GETBY(DONID, vLoaian, TOAANID, BMID, 1);
                trDuongsu.Visible = true;
                //oDTDS = oBL.ADS_TONGDAT_DOITUONG_GETBY(DONID, TOAANID, BMID, 1);
                //trDuongsu.Visible = true;
            }
            if (trDuongsu.Visible)
            {
                if (hddIsTructuyen.Value == "1")
                {
                    DataTable dtTructuyen = CreateTable();
                    DataTable dtTructiep = CreateTable();
                    string strarrOnline = "," + hddarrDuongsuTructuyen.Value + ",";
                    foreach (DataRow r in oDTDS.Rows)
                    {
                        string strDSID = r["ID"] + "";
                        //if (strarrOnline.Contains("," + strDSID + ","))
                        if (r["HINHTHUCGUI"].ToString() == "1")
                        {//Online
                            DataRow rOnline = dtTructuyen.NewRow();
                            rOnline["ID"] = r["ID"];
                            rOnline["TUCACHTOTUNG_MA"] = r["TUCACHTOTUNG_MA"];
                            rOnline["TENDUONGSU"] = r["TENDUONGSU"];
                            rOnline["DAGUI"] = r["DAGUI"];
                            rOnline["TRANGTHAI"] = r["TRANGTHAI"];
                            rOnline["NGAYGUI"] = r["NGAYGUI"];
                            rOnline["NGAYNHANTONGDAT"] = r["NGAYNHANTONGDAT"];
                            rOnline["TENTCTT"] = r["TENTCTT"];
                            dtTructuyen.Rows.Add(rOnline);
                        }
                        else
                        {
                            DataRow rTructiep = dtTructiep.NewRow();
                            rTructiep["ID"] = r["ID"];
                            rTructiep["TUCACHTOTUNG_MA"] = r["TUCACHTOTUNG_MA"];
                            rTructiep["TENDUONGSU"] = r["TENDUONGSU"];
                            rTructiep["DAGUI"] = r["DAGUI"];
                            rTructiep["TRANGTHAI"] = r["TRANGTHAI"];
                            rTructiep["NGAYGUI"] = r["NGAYGUI"];
                            rTructiep["NGAYNHANTONGDAT"] = r["NGAYNHANTONGDAT"];
                            rTructiep["TENTCTT"] = r["TENTCTT"];
                            rTructiep["HINHTHUCGUI"] = r["HINHTHUCGUI"];
                            dtTructiep.Rows.Add(rTructiep);
                        }
                    }

                    dgTructiep.DataSource = dtTructiep;
                    dgTructiep.DataBind();
                    dgTructuyen.DataSource = dtTructuyen;
                    dgTructuyen.DataBind();
                }
                else
                {
                    dgTructiep.DataSource = oDTDS;
                    dgTructiep.DataBind();
                }
            }
            if (dgTructiep.Items.Count == 0) trDuongsu.Visible = false;
            if (dgTructuyen.Items.Count == 0) trTructuyen.Visible = false;

        }
        private DataTable CreateTable()
        {
            DataTable oDT = new DataTable();
            oDT.Columns.Add(new DataColumn("ID", Type.GetType("System.Decimal")));
            oDT.Columns.Add(new DataColumn("TUCACHTOTUNG_MA", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("TENDUONGSU", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("DAGUI", Type.GetType("System.Decimal")));
            oDT.Columns.Add(new DataColumn("TRANGTHAI", Type.GetType("System.Decimal")));
            oDT.Columns.Add(new DataColumn("NGAYGUI", Type.GetType("System.DateTime")));
            oDT.Columns.Add(new DataColumn("NGAYNHANTONGDAT", Type.GetType("System.DateTime")));
            oDT.Columns.Add(new DataColumn("TENTCTT", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("HINHTHUCGUI", Type.GetType("System.String")));
            oDT.AcceptChanges();
            return oDT;
        }
        protected void chkIsSend_CheckChange(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;

            foreach (DataGridItem Item in dgTructiep.Items)
            {
                CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                if (Item.Cells[0].Text.Equals(chk.ToolTip))
                {
                    txtNgaygui.Visible = txtNgayNhan.Visible = chk.Checked;
                    if (chk.Checked)
                    {
                        if (txtNgaygui.Text == "")
                            txtNgaygui.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    }
                }
            }
        }
        protected void chkIsSendTT_CheckChange(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;

            foreach (DataGridItem Item in dgTructuyen.Items)
            {
                CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSendTT");
                TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                txtNgaygui.Enabled = txtNgayNhan.Enabled = false;
                if (Item.Cells[0].Text.Equals(chk.ToolTip))
                {
                    txtNgaygui.Visible = txtNgayNhan.Visible = chk.Checked;
                    if (chk.Checked)
                    {
                        if (txtNgaygui.Text == "")
                            txtNgaygui.Text = txtNgayNhan.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    }
                }
            }
        }
        protected void rdbIsVKS_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtVKS_Ngaygui.Visible = lblVKSNgaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = rdbIsVKS.SelectedValue == "1" ? true : false;
            if (rdbIsVKS.SelectedValue == "1" && txtVKS_Ngaygui.Text == "") txtVKS_Ngaygui.Text = DateTime.Now.ToString("dd/MM/yyyy");
        }
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoad.HasFile)
            {
                string strFileName = AsyncFileUpLoad.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoad.SaveAs(path);
                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            }
        }
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            decimal IDFILE = Convert.ToDecimal(hddFile.Value);
            //ADS_FILE oF = dt.ADS_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
            if (vLoaian == 1)
            {
                AHS_FILE oF = dt.AHS_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                if (oF != null)
                {
                    if (oF.TENFILE != null)
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oF.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oF.TENFILE + "&Extension=" + oF.KIEUFILE + "';", true);
                    }
                }
            }
            else if (vLoaian == 2)
            {
                ADS_FILE oF = dt.ADS_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                if (oF != null)
                {
                    if (oF.TENFILE != null)
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oF.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oF.TENFILE + "&Extension=" + oF.KIEUFILE + "';", true);
                    }
                }
            }
            else if (vLoaian == 3)
            {
                AHN_FILE oF = dt.AHN_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                if (oF != null)
                {
                    if (oF.TENFILE != null)
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oF.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oF.TENFILE + "&Extension=" + oF.KIEUFILE + "';", true);
                    }
                }
            }
            else if (vLoaian == 4)
            {
                AKT_FILE oF = dt.AKT_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                if (oF != null)
                {
                    if (oF.TENFILE != null)
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oF.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oF.TENFILE + "&Extension=" + oF.KIEUFILE + "';", true);
                    }
                }
            }
            else if (vLoaian == 5)
            {
                ALD_FILE oF = dt.ALD_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                if (oF != null)
                {
                    if (oF.TENFILE != null)
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oF.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oF.TENFILE + "&Extension=" + oF.KIEUFILE + "';", true);
                    }
                }
            }
            else if (vLoaian == 6)
            {
                AHC_FILE oF = dt.AHC_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                if (oF != null)
                {
                    if (oF.TENFILE != null)
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oF.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oF.TENFILE + "&Extension=" + oF.KIEUFILE + "';", true);
                    }
                }
            }
        }
       
        private void Update_ADS_SOTHAM_BANAN_ANPHI(decimal DonID, decimal DuongSuID, DateTime? NgayNhan)
        {
            ADS_SOTHAM_BANAN ba = dt.ADS_SOTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
            if (ba != null)
            {
                bool isNew = false;
                ADS_SOTHAM_BANAN_ANPHI ba_ap = dt.ADS_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DonID && x.DUONGSU == DuongSuID).FirstOrDefault();
                if (ba_ap == null)
                {
                    isNew = true;
                    ba_ap = new ADS_SOTHAM_BANAN_ANPHI();
                }
                ba_ap.DONID = DonID;
                ba_ap.DUONGSU = DuongSuID;
                ba_ap.NGAYNHANAN = NgayNhan;
                if (isNew)
                {
                    //update 14082025
                    if (ba_ap.TOA_GIAIQUYET_ID == null) ba_ap.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ADS_SOTHAM_BANAN_ANPHI.Add(ba_ap);
                }
                dt.SaveChanges();
            }
        }
        private void Update_AHC_SOTHAM_BANAN_ANPHI(decimal DonID, decimal DuongSuID, DateTime? NgayNhan)
        {
            AHC_SOTHAM_BANAN ba = dt.AHC_SOTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
            if (ba != null)
            {
                bool isNew = false;
                AHC_SOTHAM_BANAN_ANPHI ba_ap = dt.AHC_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DonID && x.DUONGSU == DuongSuID).FirstOrDefault();
                if (ba_ap == null)
                {
                    isNew = true;
                    ba_ap = new AHC_SOTHAM_BANAN_ANPHI();
                }
                ba_ap.DONID = DonID;
                ba_ap.DUONGSU = DuongSuID;
                ba_ap.NGAYNHANAN = NgayNhan;
                if (isNew)
                {
                    dt.AHC_SOTHAM_BANAN_ANPHI.Add(ba_ap);
                }
                dt.SaveChanges();
            }
        }
        private void Update_AHN_SOTHAM_BANAN_ANPHI(decimal DonID, decimal DuongSuID, DateTime? NgayNhan)
        {
            AHN_SOTHAM_BANAN ba = dt.AHN_SOTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
            if (ba != null)
            {
                bool isNew = false;
                AHN_SOTHAM_BANAN_ANPHI ba_ap = dt.AHN_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DonID && x.DUONGSU == DuongSuID).FirstOrDefault();
                if (ba_ap == null)
                {
                    isNew = true;
                    ba_ap = new AHN_SOTHAM_BANAN_ANPHI();
                }
                ba_ap.DONID = DonID;
                ba_ap.DUONGSU = DuongSuID;
                ba_ap.NGAYNHANAN = NgayNhan;
                if (isNew)
                {
                    // an hn
                    if (ba_ap.TOA_GIAIQUYET_ID == null) 
                        ba_ap.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    
                    dt.AHN_SOTHAM_BANAN_ANPHI.Add(ba_ap);
                }
                dt.SaveChanges();
            }
        }
        private void Update_AHS_SOTHAM_BANAN_BICAO(decimal VuAnID, decimal BiCaoID, DateTime? NgayNhan)
        {
            AHS_SOTHAM_BANAN ba = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
            if (ba != null)
            {
                bool isNew = false;
                AHS_SOTHAM_BANAN_BICAO ba_bc = dt.AHS_SOTHAM_BANAN_BICAO.Where(x => x.BANANID == ba.ID && x.BICAOID == BiCaoID).FirstOrDefault();
                if (ba_bc == null)
                {
                    isNew = true;
                    ba_bc = new AHS_SOTHAM_BANAN_BICAO();
                }
                ba_bc.BANANID = ba.ID;
                ba_bc.BICAOID = BiCaoID;
                ba_bc.NGAYNHANBANAN = NgayNhan;
                if (isNew)
                {
                    // insert toa_gq_id
                    ba_bc.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHS_SOTHAM_BANAN_BICAO.Add(ba_bc);
                }
                dt.SaveChanges();
            }
        }
        private void Update_AHS_PHUCTHAM_BANAN_BICAO(decimal VuAnID, decimal BiCaoID, DateTime? NgayNhan)
        {
            AHS_PHUCTHAM_BANAN ba = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
            if (ba != null)
            {
                bool isNew = false;
                AHS_PHUCTHAM_BANAN_BICAO ba_bc = dt.AHS_PHUCTHAM_BANAN_BICAO.Where(x => x.BANANID == ba.ID && x.BICAOID == BiCaoID).FirstOrDefault();
                if (ba_bc == null)
                {
                    isNew = true;
                    ba_bc = new AHS_PHUCTHAM_BANAN_BICAO();
                }
                ba_bc.BANANID = ba.ID;
                ba_bc.BICAOID = BiCaoID;
                ba_bc.NGAYNHANBANAN = NgayNhan;
                if (isNew)
                {
                    // insert toa_gq_id
                    ba_bc.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHS_PHUCTHAM_BANAN_BICAO.Add(ba_bc);
                }
                dt.SaveChanges();
            }
        }
        private void Update_AKT_SOTHAM_BANAN_ANPHI(decimal DonID, decimal DuongSuID, DateTime? NgayNhan)
        {
            AKT_SOTHAM_BANAN ba = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
            if (ba != null)
            {
                bool isNew = false;
                AKT_SOTHAM_BANAN_ANPHI ba_ap = dt.AKT_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DonID && x.DUONGSU == DuongSuID).FirstOrDefault();
                if (ba_ap == null)
                {
                    isNew = true;
                    ba_ap = new AKT_SOTHAM_BANAN_ANPHI();
                }
                ba_ap.DONID = DonID;
                ba_ap.DUONGSU = DuongSuID;
                ba_ap.NGAYNHANAN = NgayNhan;
                if (isNew)
                {
                    dt.AKT_SOTHAM_BANAN_ANPHI.Add(ba_ap);
                }
                dt.SaveChanges();
            }
        }
        private void Update_ALD_SOTHAM_BANAN_ANPHI(decimal DonID, decimal DuongSuID, DateTime? NgayNhan)
        {
            ALD_SOTHAM_BANAN ba = dt.ALD_SOTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
            if (ba != null)
            {
                bool isNew = false;
                ALD_SOTHAM_BANAN_ANPHI ba_ap = dt.ALD_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DonID && x.DUONGSU == DuongSuID).FirstOrDefault();
                if (ba_ap == null)
                {
                    isNew = true;
                    ba_ap = new ALD_SOTHAM_BANAN_ANPHI();
                }
                ba_ap.DONID = DonID;
                ba_ap.DUONGSU = DuongSuID;
                ba_ap.NGAYNHANAN = NgayNhan;
                
                // quyennd
                if (ba_ap.TOA_GIAIQUYET_ID == null)
                    ba_ap.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                
                if (isNew)
                {
                    dt.ALD_SOTHAM_BANAN_ANPHI.Add(ba_ap);
                }
                dt.SaveChanges();
            }
        }
        private void Update_APS_SOTHAM_BANAN_ANPHI(decimal DonID, decimal DuongSuID, DateTime? NgayNhan)
        {
            APS_SOTHAM_BANAN ba = dt.APS_SOTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
            if (ba != null)
            {
                bool isNew = false;
                APS_SOTHAM_BANAN_ANPHI ba_ap = dt.APS_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DonID && x.DUONGSU == DuongSuID).FirstOrDefault();
                if (ba_ap == null)
                {
                    isNew = true;
                    ba_ap = new APS_SOTHAM_BANAN_ANPHI();
                }
                ba_ap.DONID = DonID;
                ba_ap.DUONGSU = DuongSuID;
                ba_ap.NGAYNHANAN = NgayNhan;
                if (isNew)
                {
                    dt.APS_SOTHAM_BANAN_ANPHI.Add(ba_ap);
                }
                dt.SaveChanges();
            }
        }

    }
}