using BL.GSTP;
using BL.GSTP.ALD;
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
using BL.GSTP.TP_THADS;
using System.Net;
using Newtonsoft.Json;
using System.Configuration;
using System.Text;
using BL.GSTP.BANGSETGET;
using BL.GSTP.ADS;

namespace WEB.GSTP.QLAN.ALD.XuLyDon
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public string sDONID = "0";
        public string sID = "0";
        private void SetDonGhep()
        {
            //DONGHEP.Visible = false;
            string keyDonID = "THONGTIN.DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            string keyLoaiAnId = "THONGTIN.DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            Session[keyDonID] = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG]);
            Session[keyLoaiAnId] = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                sDONID = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                try
                {
                    SetDonGhep();
                    txtNgayGQ.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    LoadDropBienPhapGQ();
                    pnCDTN.Visible = pnCDNN.Visible = pnTraDon.Visible = false;
                    pnThuLy.Visible = true;
                    pnThongbao.Visible = false;
                    string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                    decimal DONID = current_id == "" ? 0 : Convert.ToDecimal(current_id);
                    CheckQuyen(DONID);
                    LoadDropDuongSu(DONID);
                    ALD_DON_XULY oDXuly = dt.ALD_DON_XULY.Where(x => x.DONID == DONID && x.LOAIGIAIQUYET == 1).FirstOrDefault();
                    if (oDXuly != null)
                    {
                        ALD_CHUYEN_NHAN_AN ca = dt.ALD_CHUYEN_NHAN_AN.Where(x => x.VUANID == DONID).FirstOrDefault();
                        if (ca != null)
                        {

                            lbtthongbao.Text = "Đơn đã chuyển sang tòa án khác xử lý !";
                            Cls_Comon.SetButton(cmdCapNhat, false);
                            //Cls_Comon.SetButton(cmdThemmoi, false);
                            Cls_Comon.SetButton(cmdCapNhatAP, false);
                            Cls_Comon.SetButton(cmdThemmoiAP, false);
                            hddShowCommand.Value = "False";
                            hddShowCommandAP.Value = "False";
                        }
                    }
                    ALD_CHUYEN_NHAN_AN objCN = dt.ALD_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == DONID && x.TRUONGHOPGIAONHANID == 266).FirstOrDefault();
                    if (objCN != null)
                    {//nếu là đơn chuyển trong hệ thống toà án thì không check
                        ALD_DON_XULY oldDonXuLy = dt.ALD_DON_XULY.Where(x => x.DONID == objCN.VUANID && x.LOAIGIAIQUYET == 1).FirstOrDefault();
                        if (oldDonXuLy == null)
                        {
                            lbtthongbao.Text = "Án được chuyển đến, không được sửa đổi!";
                            Cls_Comon.SetButton(cmdCapNhat, false);
                            Cls_Comon.SetButton(cmdCapNhatAP, false);
                            Cls_Comon.SetButton(cmdThemmoiAP, false);
                            hddShowCommand.Value = "False";
                            hddShowCommandAP.Value = "False";
                        }
                    }
                    LoadGrid_XuLyDon();
                    LoadGrid_AnPhi();
                }
                catch (Exception ex) { lbtthongbao.Text = ex.Message; }
            }
        }
        void SetNewSoTB()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ALD_DON_BL oSTBL = new ALD_DON_BL();
            //Số Thông báo mới
            DateTime ngayTB;
            if (!String.IsNullOrEmpty(txtNgaythongbao.Text))
                ngayTB = DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else
                ngayTB = DateTime.Now;

            String STTNew = oSTBL.GET_STB_XLDon_NEW_V2(DonViID, "ALD", ngayTB).ToString();
            txtSothongbao.Text = STTNew;

        }
        protected void txtNgaythongbao_TextChanged(object sender, EventArgs e)
        {
            if (hddCurrID.Value == "0" || hddCurrID.Value == "")
                SetNewSoTB();
        }
        private void LoadGrid_AnPhi()
        {
            ALD_DON_BL oBL = new ALD_DON_BL();
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            int page_size = 20, count_all = 0;
            int pageindex = Convert.ToInt32(hddPageIndexAP.Value);

            DataTable oDT = oBL.ALD_ANPHI_GETBYDONID_V2(DONID, 1, pageindex, page_size);
            if (oDT.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                hddTotalPageAP.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiTAP.Text = lstSobanghiBAP.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPageAP.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPageAP, hddPageIndexAP, lbTFirstAP, lbBFirstAP, lbTLastAP, lbBLastAP, lbTNextAP, lbBNextAP, lbTBackAP, lbBBackAP, lbTStep1AP, lbBStep1AP, lbTStep2AP,
                             lbBStep2AP, lbTStep3AP, lbBStep3AP, lbTStep4AP, lbBStep4AP, lbTStep5AP, lbBStep5AP, lbTStep6AP, lbBStep6AP);
                #endregion
            }
            else
            {
                hddTotalPageAP.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPageAP, hddPageIndexAP, lbTFirstAP, lbBFirstAP, lbTLastAP, lbBLastAP, lbTNextAP, lbBNextAP, lbTBackAP, lbBBackAP, lbTStep1AP, lbBStep1AP, lbTStep2AP,
                           lbBStep2AP, lbTStep3AP, lbBStep3AP, lbTStep4AP, lbBStep4AP, lbTStep5AP, lbBStep5AP, lbTStep6AP, lbBStep6AP);
                lstSobanghiTAP.Text = lstSobanghiBAP.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }

            rptAP.DataSource = oDT;
            rptAP.DataBind();
        }

        private void CheckQuyen(decimal DONID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            //Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
            Cls_Comon.SetButton(cmdCapNhat, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdThemmoiAP, oPer.TAOMOI);
            Cls_Comon.SetButton(cmdCapNhatAP, oPer.CAPNHAT);


            ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
            if (oT != null)
            {
                hddNgayNhanDon.Value = oT.NGAYNHANDON + "" == "" ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy");
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbtthongbao.Text = lbThongbaoAP.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    //Cls_Comon.SetButton(cmdThemmoi, false);
                    Cls_Comon.SetButton(cmdCapNhat, false);
                    hddShowCommand.Value = "False";
                    Cls_Comon.SetButton(cmdThemmoiAP, false);
                    Cls_Comon.SetButton(cmdCapNhatAP, false);
                    hddShowCommandAP.Value = "False";

                    return;
                }
            }

            List<ALD_DON_THAMPHAN> lstCount = dt.ALD_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).ToList();
            if (lstCount.Count == 0)
            {
                lbtthongbao.Text = lbThongbaoAP.Text = "Chưa phân công thẩm phán giải quyết đơn !";
                //Cls_Comon.SetButton(cmdThemmoi, false);
                Cls_Comon.SetButton(cmdCapNhat, false);
                hddShowCommand.Value = "False";
                Cls_Comon.SetButton(cmdThemmoiAP, false);
                Cls_Comon.SetButton(cmdCapNhatAP, false);
                hddShowCommandAP.Value = "False";
                return;
            }
            //List<ALD_SOTHAM_THULY> lstTL = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == DONID).ToList();
            //if (lstTL.Count > 0)
            //{
            //    lbtthongbao.Text = lbThongbaoAP.Text = "Chưa phân công thẩm phán giải quyết đơn !";
            //    Cls_Comon.SetButton(cmdThemmoi, false);
            //    Cls_Comon.SetButton(cmdCapNhat, false);
            //    hddShowCommand.Value = "False";
            //    Cls_Comon.SetButton(cmdThemmoiAP, false);
            //    Cls_Comon.SetButton(cmdCapNhatAP, false);
            //    hddShowCommandAP.Value = "False";
            //    return;
            //}

            if (txtDuongSu.Text == "")
            {
                Cls_Comon.SetButton(cmdCapNhat, false);
            }

            //CheckQuyenAP(DONID);
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new ALD_CHUYEN_NHAN_AN_BL().Check_NhanAn(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbtthongbao.Text = Result;
                lbThongbaoAP.Text = Result;
                //Cls_Comon.SetButton(cmdThemmoi, false);
                Cls_Comon.SetButton(cmdCapNhat, false);
                hddShowCommand.Value = "False";
                Cls_Comon.SetButton(cmdThemmoiAP, false);
                Cls_Comon.SetButton(cmdCapNhatAP, false);
                hddShowCommandAP.Value = "False";
                return;

            }
        }
        private void CheckQuyenAP(decimal? ID)
        {
            List<ALD_DON_XULY> lstXL = dt.ALD_DON_XULY.Where(x => x.DONID == ID && x.LOAIGIAIQUYET == 5).ToList();
            if (lstXL.Count == 0)
            {
                Cls_Comon.SetButton(cmdThemmoiAP, false);
                Cls_Comon.SetButton(cmdCapNhatAP, false);
            }
            else
            {
                Cls_Comon.SetButton(cmdThemmoiAP, true);
                Cls_Comon.SetButton(cmdCapNhatAP, true);
            }
        }

        void LoadDropBienPhapGQ()
        {
            dropBienPhapGQ.Items.Clear();
            dropBienPhapGQ.Items.Add(new ListItem("Chuyển đơn trong Hệ thống Tòa án", ENUM_ALD_BIENPHAPGQ.ALD_ChuyenDonTrongNganh));
            //dropBienPhapGQ.Items.Add(new ListItem("Chuyển đơn ngoài ngành", ENUM_ALD_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh));
            dropBienPhapGQ.Items.Add(new ListItem("Trả lại đơn", ENUM_ALD_BIENPHAPGQ.ALD_TraLaiDon));
            dropBienPhapGQ.Items.Add(new ListItem("Yêu cầu bổ sung đơn", ENUM_ALD_BIENPHAPGQ.ALD_YCBoSungDon));
            dropBienPhapGQ.Items.Add(new ListItem("Thụ lý vụ việc", ENUM_ALD_BIENPHAPGQ.ALD_ThuLy));
            dropBienPhapGQ.SelectedValue = ENUM_ALD_BIENPHAPGQ.ALD_ThuLy;
            dropBienPhapGQ.Items.Add(new ListItem("Đơn trùng", ENUM_ALD_BIENPHAPGQ.ALD_DonTrung));
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            //Danh mục lý do tra đơn
            ddlLyTradon.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LYDOTRADON);
            ddlLyTradon.DataTextField = "TEN";
            ddlLyTradon.DataValueField = "ID";
            ddlLyTradon.DataBind();
        }

        //hieu lấy danh sách nguyên đơn đại diện
        void LoadDropDuongSu(decimal DONID)
        {
            ddlDuongSu.Items.Clear();
            lbThongbaoAP.Text = "";
            ALD_DON_DUONGSU_BL oDSBL = new ALD_DON_DUONGSU_BL();
            //Danh mục lý do tra đơn
            DataTable obj = oDSBL.ALD_DON_DUONGSU_ANPHI(DONID);

            ddlDuongSu.DataSource = obj;
            ddlDuongSu.DataTextField = "TENDUONGSU";
            ddlDuongSu.DataValueField = "ID";
            ddlDuongSu.Items.Add(new ListItem("0", "0"));
            ddlDuongSu.DataBind();
            ddlDuongSu.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlDuongSu.SelectedIndex = 0;
            if (obj.Rows.Count == 0)
            {
                lbThongbaoAP.Text = "Bạn không thể thêm thông tin án phí khi chưa xử lý đơn!";
                Cls_Comon.SetButton(cmdThemmoiAP, false);
                Cls_Comon.SetButton(cmdCapNhatAP, false);
            }
            else
            {
                Cls_Comon.SetButton(cmdThemmoiAP, true);
                Cls_Comon.SetButton(cmdCapNhatAP, true);
            }
        }

        private void LoadGrid_XuLyDon()
        {
            ALD_DON_XULY_BL oBL = new ALD_DON_XULY_BL();
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            DataTable oDT = oBL.GetByDonID(DONID, pageindex, page_size);
            if (oDT.Rows.Count > 0)
            {
                DataRow row_last = oDT.Rows[0];
                //  LoadInfo_XuLyDon(Convert.ToDecimal(row_last["ID"] + ""));

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(oDT.Rows.Count, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {

                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }

            rpt.DataSource = oDT;
            rpt.DataBind();
        }

        protected void rpt_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal CurrID = 0, DonID = 0, DonChiTietID = 0;
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Them":
                    string[] IDThem = e.CommandArgument.ToString().Split(',');
                    hddCurrID.Value = "0";
                    DonID = Convert.ToDecimal(IDThem[0].ToString() == "" ? "0" : IDThem[0].ToString());
                    hddChiTietID.Value = IDThem[1].ToString();
                    DonChiTietID = Convert.ToDecimal(IDThem[1].ToString() == "" ? "0" : IDThem[1].ToString());
                    lbtthongbao.Text = "";
                    if (DonID > 0)
                    {
                        ALD_DON_DUONGSU dds = dt.ALD_DON_DUONGSU.Where(x => x.DONID == DonID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == "NGUYENDON").FirstOrDefault();
                        txtDuongSu.Text = dds.TENDUONGSU;
                    }
                    else
                    {
                        var a = (from d in dt.DON_DUONGSU_CHITIET
                                 join s in dt.ALD_DON_DUONGSU on d.DUONGSUID equals s.ID
                                 where d.DONCHITIETID == DonChiTietID && s.TUCACHTOTUNG_MA == "NGUYENDON"
                                 select new
                                 {
                                     s.TENDUONGSU,
                                 }).FirstOrDefault();
                        txtDuongSu.Text = a.TENDUONGSU;
                    }

                    Cls_Comon.SetButton(cmdCapNhat, true);
                    break;
                case "Sua":
                    string[] IDSua = e.CommandArgument.ToString().Split(',');
                    CurrID = Convert.ToDecimal(IDSua[0]);
                    hddCurrID.Value = CurrID.ToString();
                    DonID = Convert.ToDecimal(IDSua[1].ToString() == "" ? "0" : IDSua[1].ToString());
                    DonChiTietID = Convert.ToDecimal(IDSua[2].ToString() == "" ? "0" : IDSua[2].ToString());
                    btnin.Visible = false;
                    lbtthongbao.Text = "";
                    if (DonID > 0)
                    {
                        ALD_DON_DUONGSU dds = dt.ALD_DON_DUONGSU.Where(x => x.DONID == DonID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == "NGUYENDON").FirstOrDefault();
                        txtDuongSu.Text = dds.TENDUONGSU;
                    }
                    else
                    {
                        var a = (from d in dt.DON_DUONGSU_CHITIET
                                 join s in dt.ALD_DON_DUONGSU on d.DUONGSUID equals s.ID
                                 where d.DONCHITIETID == DonChiTietID && s.TUCACHTOTUNG_MA == "NGUYENDON"
                                 select new
                                 {
                                     s.TENDUONGSU,
                                 }).FirstOrDefault();
                        txtDuongSu.Text = a.TENDUONGSU;
                    }
                    LoadInfo_XuLyDon(CurrID);
                    if (hddShowCommand.Value == "True") Cls_Comon.SetButton(cmdCapNhat, true);
                    break;
                case "Xoa":
                    CurrID = Convert.ToDecimal(e.CommandArgument.ToString());
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    ALD_DON_XULY oT = dt.ALD_DON_XULY.Where(x => x.ID == CurrID).FirstOrDefault();
                    if ((oT.CDTN_TOAANID + "") == (Session[ENUM_SESSION.SESSION_DONVIID] + ""))
                    {
                        lbtthongbao.Text = "Bạn không thể xóa nội dung tòa án khác cập nhật!";
                        return;
                    }
                    decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + ""); ;
                    // khong duoc xoa khi da Tong dat
                    ALD_TONGDAT oTD = dt.ALD_TONGDAT.Where(x => x.DONID == oT.DONID).FirstOrDefault();
                    if (oTD != null)
                    {
                        lbtthongbao.Text = "Bạn không thể xóa khi đã đạt!";
                        return;
                    }

                    string MATHONGBAO = "";
                    var DVCQG_THANH_TOAN = DataExtensions.GetAllWithClause<BL.GSTP.BANGSETGET.DVCQG_THANH_TOAN>("ANPHI_ID = " + CurrID + " AND MALOAIVUVIEC = '5'");
                    if (DVCQG_THANH_TOAN != null)
                    {
                        if (DVCQG_THANH_TOAN.Count() > 0)
                        {
                            MATHONGBAO = DVCQG_THANH_TOAN.FirstOrDefault().MA_THONGBAO;
                        }
                    }
                    DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                    decimal _VALUE = 0;
                    obj.DVCQG_THANH_TOAN_DELETE_XULY(CurrID, "5", ref _VALUE);
                    if (_VALUE == 1)
                    {
                        decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new ALD_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        if (Result != "")
                        {
                            lbtthongbao.Text = Result;
                            return;
                        }
                        decimal FileID = 0;
                        if (oT.FILEID != null) FileID = (decimal)oT.FILEID;
                        //manh them xoa An phi
                        ALD_ANPHI oAnphi = dt.ALD_ANPHI.Where(x => x.DONID == oT.DONID).FirstOrDefault();
                        if (oAnphi != null)
                        {
                            //anhpn add log án phí 08/01/2025
                            string CONTENT_JSON = null;
                            string CONTENT_JSON_OLD = JsonConvert.SerializeObject(oAnphi, Formatting.Indented);

                            LOG_THONGTINANPHI_QLTA log = new LOG_THONGTINANPHI_QLTA();
                            log.InsertLog(Session[ENUM_LOAIAN.AN_LAODONG].ToString(), CurrID.ToString(), MATHONGBAO, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Delete", CONTENT_JSON, CONTENT_JSON_OLD);

                            dt.ALD_ANPHI.Remove(oAnphi);
                        }

                        //-----

                        dt.ALD_DON_XULY.Remove(oT);
                        DeleteDonChuyenToaAnKhac(oT);
                        //DONGHEP.DeleteDonChiTiet(oT.ID);
                        //xóa YCBS
                        if (oT.LOAIGIAIQUYET == 4 || oT.LOAIGIAIQUYET == 5)
                        {
                            ADS_DON_XULY_BL oBL = new ADS_DON_XULY_BL();
                            DataTable oYC = oBL.ALD_GETALL_DON_YCBS(DonID, CurrID, 1, 5);
                            // vnpt update 120825: check rong
                            if (oYC.Rows.Count > 0) oBL.DEL_DON_YCBS_GETBYDONID(Convert.ToDecimal(oYC.Rows[0]["ID"].ToString()));
                        }
                        dt.SaveChanges();
                        if (FileID > 0)
                        {
                            try
                            {
                                ALD_FILE objf = dt.ALD_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                                dt.ALD_FILE.Remove(objf);
                                dt.SaveChanges();
                            }
                            catch (Exception ex) { }
                        }
                        hddPageIndex.Value = "1";
                        LoadGrid_XuLyDon();
                        Resetcontrol();
                        LoadDropDuongSu(DonID);
                        lbtthongbao.Text = "Xóa thành công!";
                        //CheckQuyenAP(ID);
                    }
                    else
                    {
                        lbtthongbao.Text = "Đã phát sinh giao dịch thanh toán, bạn không được Xóa!";
                    }
                    break;
                case "Download":
                    CurrID = Convert.ToDecimal(e.CommandArgument.ToString());
                    var oND = dt.ALD_FILE.Where(x => x.ID == CurrID).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                    }
                    break;
                case "BoSung":
                    CurrID = Convert.ToDecimal(e.CommandArgument.ToString());
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv();");
                    string link = "/QLAN/ALD/XuLyDon/Popup/pBoSungTaiLieu.aspx?ID=" + CurrID;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(950/2); var Mtop = (screen.height/2)-(600/2); javascript:window.open('" + link + "', '_blank', 'height=600px,width=950px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=no,scrollbars=0'); ", true); break;
                case "TraLaiDon":
                    CurrID = Convert.ToDecimal(e.CommandArgument.ToString());
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv();");
                    string linkPop = "/QLAN/ALD/XuLyDon/Popup/pTraLaiDon.aspx?ID=" + CurrID;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(950/2); var Mtop = (screen.height/2)-(600/2); javascript:window.open('" + linkPop + "', '_blank', 'height=600px,width=950px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=no,scrollbars=0'); ", true); break;
            }
        }

        void LoadInfo_XuLyDon(Decimal CurrID)
        {
            //DONGHEP.Visible = false;
            ALD_DON_XULY obj = dt.ALD_DON_XULY.Where(x => x.ID == CurrID).Single<ALD_DON_XULY>();
            if (obj != null)
            {
                if ((obj.CDTN_TOAANID + "") == (Session[ENUM_SESSION.SESSION_DONVIID] + ""))
                {
                    lbtthongbao.Text = "Bạn không thể sửa nội dung của tòa án khác cập nhật!";
                    Cls_Comon.SetButton(cmdCapNhat, false);
                }
                txtNgayGQ.Text = (((DateTime)obj.NGAYGQ_YC) == DateTime.MinValue) ? "" : ((DateTime)obj.NGAYGQ_YC).ToString("dd/MM/yyyy", cul);
                txtLyDo.Text = obj.LYDO;

                txtSothongbao.Text = obj.SOTHONGBAO;
                ddlStbPhu.SelectedValue = obj.STB_PHU;
                //txtSothongbao.Enabled = false;

                if (obj.NGAYTHONGBAO != null)
                    txtNgaythongbao.Text = (((DateTime)obj.NGAYTHONGBAO) == DateTime.MinValue) ? "" : ((DateTime)obj.NGAYTHONGBAO).ToString("dd/MM/yyyy", cul);

                hddFileid.Value = obj.FILEID + "";
                if ((obj.FILEID + "") != "" && (obj.FILEID + "") != "0")
                {
                    ALD_FILE objFile = dt.ALD_FILE.Where(x => x.ID == obj.FILEID).FirstOrDefault();
                    if (objFile != null && objFile.TENFILE != null) lbtDownload.Visible = true;
                }
                else
                    lbtDownload.Visible = false;
                dropBienPhapGQ.SelectedValue = obj.LOAIGIAIQUYET + "";
                string bienphap = dropBienPhapGQ.SelectedValue;
                lblNgayGQ.Text = "Ngày GQ/YC";
                lblLydo.Text = "Lý do";
                switch (bienphap)
                {
                    case ENUM_ALD_BIENPHAPGQ.ALD_ChuyenDonNgoaiNganh:
                        pnCDNN.Visible = true;
                        pnCDTN.Visible = pnTraDon.Visible = pnYCBS.Visible = false;
                        pnThongbao.Visible = true;
                        txtCDNN_NgayChuyen.Text = (((DateTime)obj.CDNN_NGAYCHUYEN) == DateTime.MinValue) ? "" : ((DateTime)obj.CDNN_NGAYCHUYEN).ToString("dd/MM/yyyy", cul);
                        break;
                    case ENUM_ALD_BIENPHAPGQ.ALD_ChuyenDonTrongNganh:
                        //lblNgayGQ.Text = "Ngày chuyển";
                        pnCDTN.Visible = true;
                        pnCDNN.Visible = pnTraDon.Visible = pnYCBS.Visible = false;
                        pnThongbao.Visible = true;
                        break;
                    case ENUM_ALD_BIENPHAPGQ.ALD_TraLaiDon:
                        //DONGHEP.Visible = true;
                        //DONGHEP.LoadGrid();
                        //DONGHEP.SetCheckBox(CurrID);
                        pnTraDon.Visible = true;
                        pnCDTN.Visible = pnCDNN.Visible = pnYCBS.Visible = false;
                        lblLydo.Text = "Ghi chú";
                        pnThongbao.Visible = true;
                        txtTradon_Ngay.Text = (((DateTime)obj.TRADON_NGAYTRA) == DateTime.MinValue) ? "" : ((DateTime)obj.TRADON_NGAYTRA).ToString("dd/MM/yyyy", cul);
                        if (obj.TRADON_LYDOID != null)
                            ddlLyTradon.SelectedValue = obj.TRADON_LYDOID.ToString();

                        break;
                    case ENUM_ALD_BIENPHAPGQ.ALD_YCBoSungDon:
                        //DONGHEP.Visible = true;
                        //DONGHEP.LoadGrid();
                        //DONGHEP.SetCheckBox(CurrID);
                        pnYCBS.Visible = true;
                        pnTraDon.Visible = false;
                        pnCDTN.Visible = pnCDNN.Visible = false;
                        pnThongbao.Visible = true;
                        //txtNgayYCBS.Text = (((DateTime)obj.YCBS_NGAYYEUCAU) == DateTime.MinValue) ? "" : ((DateTime)obj.YCBS_NGAYYEUCAU).ToString("dd/MM/yyyy", cul);
                        txtYCBS.Text = obj.YCBS_NOIDUNG + "";
                        txtThoihanBSYC.Text = obj.YCBS_THOIHAN == null ? "" : Convert.ToDecimal(obj.YCBS_THOIHAN).ToString();

                        break;
                    case ENUM_ADS_BIENPHAPGQ.ADS_DonTrung:
                        pnCDNN.Visible = pnCDTN.Visible = pnYCBS.Visible = pnTraDon.Visible = false;
                        pnThongbao.Visible = false;
                        break;
                    default:
                        pnCDNN.Visible = pnCDTN.Visible = pnYCBS.Visible = pnTraDon.Visible = false;
                        pnThongbao.Visible = false;
                        //List<ALD_ANPHI> lstAP = dt.ALD_ANPHI.Where(x => x.DONID == obj.DONID).ToList();
                        //if (lstAP.Count > 0)
                        //{
                        //    ALD_ANPHI objAP = lstAP[0];
                        //    txtGiaTriTranhChap.Text = objAP.GIATRITRANHCHAP == null ? "" : Convert.ToDecimal(objAP.GIATRITRANHCHAP).ToString("#,#", cul);
                        //    txtMucGiamAnPhi.Text = objAP.MUCGIAMANPHI == null ? "" : Convert.ToDecimal(objAP.MUCGIAMANPHI).ToString("#,#", cul);
                        //    txtTamUngAnPhi.Text = objAP.TAMUNGANPHI == null ? "" : Convert.ToDecimal(objAP.TAMUNGANPHI).ToString("#,#", cul);

                        //    txtHanNopAnPhi.Text = String.IsNullOrEmpty(objAP.HANNOP_SONGAY + "") ? "" : objAP.HANNOP_SONGAY.ToString();
                        //    txtSoNgayGiaHan.Text = objAP.SONGAYGIAHAN + "";
                        //    if (objAP.TINHTRANG != null)
                        //        if (objAP.TINHTRANG == 1)
                        //        {
                        //            chkNopAnPhi.Checked = true;
                        //            SetEnableZoneNopAnPhi(true);
                        //        }
                        //}
                        break;
                }

                if (obj.CDTN_TOAANID > 0)
                {
                    hddToaAn.Value = obj.CDTN_TOAANID.ToString();
                    txtToaAn.Text = dt.DM_TOAAN.Where(x => x.ID == obj.CDTN_TOAANID).Single<DM_TOAAN>().MA_TEN;
                }

                txtCDNN_TenCoQuan.Text = obj.CDNN_TENCQ + "";

            }
        }


        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid_XuLyDon();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid_XuLyDon();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid_XuLyDon();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid_XuLyDon();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid_XuLyDon();
        }

        #endregion
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadGrid_XuLyDon();
        }

        //protected void btnThemmoi_Click(object sender, EventArgs e)
        //{
        //    Resetcontrol();
        //}
        void Resetcontrol()
        {
            //DONGHEP.LoadGrid();
            txtCDNN_TenCoQuan.Text = txtCDNN_NgayChuyen.Text = txtLyDo.Text = txtNgaythongbao.Text = "";
            txtNgayGQ.Text = txtToaAn.Text = "";
            txtSothongbao.Text = "";
            txtSothongbao.Enabled = true;
            hddToaAn.Value = "0";
            hddCurrID.Value = "0";
            ddlStbPhu.SelectedValue = "";
            //hddCurrID.Value = "0";
            //hddCurrAPID.Value = "0";
            //btnin.Visible = false;
            //lbtDownload.Visible = false;
            //txtNguoiNop.Text = "";
            //ddlDuongSu.SelectedValue = "0";
            //txtSothongbaoAP.Text = "";
            //txtSothongbaoAP.Enabled = true;
            //txtNgaythongbao.Text = txtNgaythongbaoAP.Text = "";
            //chkNopAnPhi.Checked = false;
            //txtTamUngAnPhi.Text = txtMucGiamAnPhi.Text = txtGiaTriTranhChap.Text = txtHanNopAnPhi.Text = txtSoNgayGiaHan.Text = "";
            //lbThongbaoAP.Text = "";
            //SetEnableZoneNopAnPhi(chkNopAnPhi.Checked);            
            Cls_Comon.SetButton(cmdCapNhat, false);
        }
        void ResetcontrolAP()
        {
            hddToaAn.Value = "0";
            hddCurrAPID.Value = "0";
            btnin.Visible = false;
            lbtDownload.Visible = false;
            ddlDuongSu.SelectedValue = "0";
            txtSothongbaoAP.Text = "";
            txtSothongbaoAP.Enabled = true;
            txtNgaythongbaoAP.Text = "";
            chkNopAnPhi.Checked = false;
            txtTamUngAnPhi.Text = txtMucGiamAnPhi.Text = txtGiaTriTranhChap.Text = txtHanNopAnPhi.Text = txtSoNgayGiaHan.Text = "";
            lbThongbaoAP.Text = "";
            SetEnableZoneNopAnPhi(chkNopAnPhi.Checked);
        }

        protected void ddlBienPhapGQ_SelectedIndexChanged(object sender, EventArgs e)
        {
            //DONGHEP.LoadGrid();
            //DONGHEP.Visible = false;
            //LoadCombobox();
            lblNgayGQ.Text = "Ngày GQ/YC";
            lblLydo.Text = "Lý do";
            string bienphap = dropBienPhapGQ.SelectedValue;
            switch (bienphap)
            {
                case ENUM_ALD_BIENPHAPGQ.ALD_ChuyenDonNgoaiNganh:

                    pnCDNN.Visible = true;
                    pnCDTN.Visible = pnTraDon.Visible = pnYCBS.Visible = false;
                    pnThongbao.Visible = true;
                    break;
                case ENUM_ALD_BIENPHAPGQ.ALD_ChuyenDonTrongNganh:
                    //lblNgayGQ.Text = "Ngày chuyển";
                    pnCDTN.Visible = true;
                    pnCDNN.Visible = pnTraDon.Visible = pnYCBS.Visible = false;
                    pnThongbao.Visible = true;
                    break;
                case ENUM_ALD_BIENPHAPGQ.ALD_TraLaiDon:
                    //DONGHEP.Visible = true;
                    pnTraDon.Visible = true;
                    pnCDTN.Visible = pnCDNN.Visible = pnYCBS.Visible = false;
                    lblLydo.Text = "Ghi chú";
                    pnThongbao.Visible = true;
                    break;
                case ENUM_ALD_BIENPHAPGQ.ALD_YCBoSungDon:
                    //DONGHEP.Visible = true;
                    pnYCBS.Visible = true;
                    pnTraDon.Visible = false;
                    pnCDTN.Visible = pnCDNN.Visible = false;
                    pnThongbao.Visible = true;
                    break;
                default:
                    pnCDNN.Visible = pnCDTN.Visible = pnYCBS.Visible = pnTraDon.Visible = false;
                    pnThongbao.Visible = false;
                    break;
            }
            txtNgayGQ.Focus();
        }

        protected void rpt_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
            ALD_DON_XULY objALD_DON_XULY = dt.ALD_DON_XULY.FirstOrDefault(x => x.DONID == DonID);

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtThem = (LinkButton)e.Item.FindControl("lblThem");
                Cls_Comon.SetLinkButton(lbtThem, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                LinkButton lbtTraLaiDon = (LinkButton)e.Item.FindControl("lbtTraLaiDon");
                LinkButton lbtBoSung = (LinkButton)e.Item.FindControl("lbtBoSung");

                bool existsAnPhiBienLai = false;

                string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtThem.Visible = false;
                    lbtXoa.Visible = false;
                    lbtTraLaiDon.Visible = false;
                }
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtThem.Visible = false;
                    lbtXoa.Visible = false;
                    lbtTraLaiDon.Visible = false;
                    if (rowView["ID"] + "" == "") lblSua.Visible = false;
                }
                else
                {
                    if (rowView["ID"] + "" == "")
                    {
                        lblSua.Visible = false;
                        lbtXoa.Visible = false;
                        lbtTraLaiDon.Visible = false;
                    }
                    else
                        lbtThem.Visible = false;



                    if (rowView["ID"] + "" == "") { lblSua.Visible = false; lbtXoa.Visible = false; } else lbtThem.Visible = false;
                    decimal DON_ID = rowView["DONID"] + "" == "" ? 0 : Convert.ToDecimal(rowView["DONID"].ToString());
                    decimal DON_gocID = rowView["DON_GOCID"] + "" == "" ? 0 : Convert.ToDecimal(rowView["DON_GOCID"].ToString());
                    //Check có án phí
                    if (rowView["ID"] + "" != "")
                    {
                        decimal idXuLy = Convert.ToDecimal((rowView["ID"] + "").ToString());
                        ALD_DON_XULY oXL = dt.ALD_DON_XULY.Where(x => x.ID == idXuLy).FirstOrDefault();
                        decimal? DONCHITIETID = oXL.DON_CHITIETID;
                        decimal ISDONCHITIET = DON_ID == 0 ? 1 : 0;
                        ALD_DON_XULY_BL oBL = new ALD_DON_XULY_BL();
                        DataTable oDT = oBL.CHECK_ALD_DON_DUONGSU_ANPHI_V2(DONID, DONCHITIETID, ISDONCHITIET);
                        if (oDT.Rows.Count > 0)
                        {
                            lblSua.Visible = false;
                            lbtXoa.Visible = false;
                            if (oDT.Rows[0]["SOBIENLAI"] != null && oDT.Rows[0]["SOBIENLAI"].ToString().Trim() != "")
                            {
                                existsAnPhiBienLai = true;
                            }
                        }
                    }

                    // Lịch sử xử lý
                    int countHistory = 0;
                    if (rowView["ID"] + "" != "")
                    {
                        //LinkButton lbtBoSung = (LinkButton)e.Item.FindControl("lbtBoSung");
                        decimal idXuLy = Convert.ToDecimal((rowView["ID"] + "").ToString());
                        ALD_DON_XULY obj = dt.ALD_DON_XULY.Where(x => x.ID == idXuLy).FirstOrDefault();
                        ADS_DON_XULY_BL oBL = new ADS_DON_XULY_BL();
                        DataTable oYC = oBL.ALD_GETALL_DON_YCBS(DONID, idXuLy, 1, 5);

                        bool existsYCBS = false;
                        decimal aldThuLy = Convert.ToDecimal(ENUM_ALD_BIENPHAPGQ.ALD_YCBoSungDon);
                        decimal adsTraLaiDon = Convert.ToDecimal(ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon);
                        countHistory = oYC.Rows.Count;

                        foreach (DataRow row in oYC.Rows)
                        {
                            decimal loaigiaiquyet = row["LOAIGIAIQUYET"].toNumber();
                            if (loaigiaiquyet.Equals(aldThuLy) || loaigiaiquyet.Equals(adsTraLaiDon))
                            {
                                existsYCBS = true;
                                break;
                            }
                        }

                        if (oYC.Rows.Count > 1 || existsYCBS)
                        {
                            lbtBoSung.Visible = true;
                        }
                        if (oYC.Rows.Count > 1)
                        {
                            lblSua.Visible = false;
                            lbtThem.Visible = false;
                            lbtXoa.Visible = false;
                        }
                    }

                    // trả lại đơn
                    if (rowView["ID"] + "" != "")
                    {
                        decimal idXuLy = Convert.ToDecimal((rowView["ID"] + "").ToString());
                        decimal adsThuLy = Convert.ToDecimal(ENUM_ALD_BIENPHAPGQ.ALD_ThuLy);
                        ALD_DON_XULY obj = dt.ALD_DON_XULY.Where(x => x.ID == idXuLy && x.LOAIGIAIQUYET == adsThuLy).FirstOrDefault();
                        //ADS_DON_XULY_BL oBL = new ADS_DON_XULY_BL();
                        //DataTable oYC = oBL.ALD_GETALL_DON_YCBS(DONID, idXuLy, 1, 5);
                        if (obj != null && countHistory <= 1)
                        {
                            lbtTraLaiDon.Visible = true;
                            //if (oYC.Rows.Count > 1)
                            //{
                            //    lblSua.Visible = false;
                            //    lbtThem.Visible = false;
                            //    lbtXoa.Visible = false;
                            //}
                        }
                        else
                        {
                            lbtTraLaiDon.Visible = false;
                        }
                    }
                    if (existsAnPhiBienLai)
                    {
                        lbtTraLaiDon.Visible = false;
                    }

                    ALD_SOTHAM_THULY oTLST = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oTLST != null)
                    {
                        lblSua.Visible = false;
                        lbtXoa.Visible = false;
                        lbtTraLaiDon.Visible = false;
                    }


                    //Check là đơn nhập
                    if (DON_gocID != DONID)
                    {
                        lblSua.Text = "Chi tiết";
                        lbtThem.Visible = false;
                        lbtXoa.Visible = false;
                    }

                    //check là đơn độc lập hoặc phản tố
                    if (rowView["LOAIDON"] + "" == "5" || rowView["LOAIDON"] + "" == "6")
                    {
                        lbtThem.Visible = lblSua.Visible = lbtXoa.Visible = false;
                    }
                }
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownload.Visible = false;
                }
                else
                {
                    lblDownload.Visible = true;
                }


                //Literal lttNoiTiepNhan = (Literal)e.Item.FindControl("lttNoiTiepNhan");

                //String bienphap = rowView["LoaiGiaiQuyet"] + "";
                //switch (bienphap)
                //{
                //    case ENUM_ALD_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                //        lttNoiTiepNhan.Text = rowView["Ten"] + "";
                //        break;
                //    case ENUM_ALD_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                //        lttNoiTiepNhan.Text = rowView["CDNN_TenCQ"] + "";
                //        break;
                //    case ENUM_ALD_BIENPHAPGQ.ADS_TraLaiDon:
                //        lttNoiTiepNhan.Text = rowView["TraDon_CanCuID"] + "";
                //        break;
                //    default:
                //        lttNoiTiepNhan.Text = "";
                //        break;
                //}

                string toagiaiquyetID = rowView["TOA_GIAIQUYET_ID"].ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                string cellValueCH = DataBinder.Eval(e.Item.DataItem, "DONID")?.ToString()?.Trim();
                decimal donId;

                if (decimal.TryParse(cellValueCH, out donId))
                {
                    if (!String.IsNullOrEmpty(toagiaiquyetID) && !toagiaiquyetID.Equals(donviID))
                    {
                        if (donviID == objALD_DON_XULY?.TOA_GIAIQUYET_ID?.ToString())
                        {
                            lbtXoa.Visible = true;
                            lblSua.Visible = true;
                        }
                        else
                        {
                            lbtXoa.Visible = false;
                            lblSua.Visible = false;
                            lbtThem.Visible = false;
                        }
                    }
                }
                //check vụ án đã kết thúc không cho sửa xóa
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lbtthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                    Cls_Comon.SetButton(cmdCapNhat, false);
                    Cls_Comon.SetButton(cmdCapNhatAP, false);
                    Cls_Comon.SetButton(cmdThemmoiAP, false);
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                    lbtThem.Visible = false;
                    lbtTraLaiDon.Visible = false;
                }
            }
        }

        private decimal UploadFileID(ALD_DON oDon, decimal FileID, string strMaBieumau, string STT, string stb_Phu)
        {
            String CurrUser = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            ALD_DON_BL oBL = new ALD_DON_BL();
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
                ALD_FILE objFile = new ALD_FILE();
                if (FileID > 0)
                    objFile = dt.ALD_FILE.Where(x => x.ID == FileID).FirstOrDefault();
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
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            objFile.NOIDUNG = buff;
                            objFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(strTenBM) + oF.Extension;
                            objFile.KIEUFILE = oF.Extension;
                        }
                        File.Delete(strFilePath);
                    }
                    catch (Exception ex) { lbtthongbao.Text = ex.Message; }
                }
                objFile.NGAYTAO = DateTime.Now;
                objFile.NGUOITAO = CurrUser;
                if (STT != "") objFile.STT = Convert.ToDecimal(STT);
                objFile.STB_PHU = stb_Phu;
                if (FileID == 0)
                {
                    // hoangndh
                    if (objFile.TOA_GIAIQUYET_ID == null)
                        objFile.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ALD_FILE.Add(objFile);
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
        private bool CheckValid()
        {
            if (txtNgayGQ.Text == "")
            {
                lbtthongbao.Text = "Bạn chưa nhập Ngày GQ/YC !";
                txtNgayGQ.Focus();
                return false;
            }
            if (!Cls_Comon.IsValidDate(txtNgayGQ.Text))
            {
                lbtthongbao.Text = "Bạn phải nhập ngày GQ/YC theo định dạng (dd/MM/yyyy) !";
                txtNgayGQ.Focus();
                return false;
            }
            DateTime dNgayGQ = (String.IsNullOrEmpty(txtNgayGQ.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayGQ.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayGQ > DateTime.Now)
            {
                lbtthongbao.Text = "Ngày GQ/YC không được lớn hơn ngày hiện tại !";
                txtNgayGQ.Focus();
                return false;
            }
            if (hddNgayNhanDon.Value != "")
            {
                DateTime NgayNhanDon = DateTime.Parse(hddNgayNhanDon.Value, cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayGQ < NgayNhanDon)
                {
                    lbtthongbao.Text = "Ngày GQ/YC không được nhỏ hơn ngày nhận đơn " + NgayNhanDon.ToString("dd/MM/yyyy") + " !";
                    txtNgayGQ.Focus();
                    return false;
                }
            }
            string bienphap = dropBienPhapGQ.SelectedValue;
            if (bienphap == ENUM_ALD_BIENPHAPGQ.ALD_ChuyenDonTrongNganh)
            {
                if (hddToaAn.Value == "0")
                {
                    lbtthongbao.Text = "Bạn chưa chọn tòa án nhận !";
                    txtToaAn.Focus();
                    return false;
                }
            }
            if (bienphap == ENUM_ALD_BIENPHAPGQ.ALD_ChuyenDonNgoaiNganh)
            {
                if (txtCDNN_TenCoQuan.Text == "")
                {
                    lbtthongbao.Text = "Bạn chưa nhập CQ/TC nhận đơn !";
                    txtCDNN_TenCoQuan.Focus();
                    return false;
                }
                if (txtCDNN_NgayChuyen.Text != "")
                {
                    if (!Cls_Comon.IsValidDate(txtCDNN_NgayChuyen.Text))
                    {
                        lbtthongbao.Text = "Bạn phải nhập ngày chuyển theo định dạng (dd/MM/yyyy) !";
                        txtCDNN_NgayChuyen.Focus();
                        return false;
                    }
                    DateTime NgayChuyen = DateTime.Parse(txtCDNN_NgayChuyen.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (NgayChuyen < dNgayGQ)
                    {
                        lbtthongbao.Text = "Ngày chuyển không được nhỏ hơn ngày GQ/YC !";
                        txtCDNN_NgayChuyen.Focus();
                        return false;
                    }
                    if (NgayChuyen > DateTime.Now)
                    {
                        lbtthongbao.Text = "Ngày chuyển không được lớn hơn ngày hiện tại !";
                        txtCDNN_NgayChuyen.Focus();
                        return false;
                    }
                }
            }
            if (bienphap == ENUM_ALD_BIENPHAPGQ.ALD_TraLaiDon)
            {
                if (txtTradon_Ngay.Text != "")
                {
                    if (!Cls_Comon.IsValidDate(txtTradon_Ngay.Text))
                    {
                        lbtthongbao.Text = "Bạn phải nhập ngày trả đơn theo định dạng (dd/MM/yyyy) !";
                        txtTradon_Ngay.Focus();
                        return false;
                    }
                    DateTime NgayTraDon = DateTime.Parse(txtTradon_Ngay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (NgayTraDon < dNgayGQ)
                    {
                        lbtthongbao.Text = "Ngày trả đơn không được nhỏ hơn ngày GQ/YC !";
                        txtTradon_Ngay.Focus();
                        return false;
                    }
                    if (NgayTraDon > DateTime.Now)
                    {
                        lbtthongbao.Text = "Ngày trả đơn không được lớn hơn ngày hiện tại !";
                        txtTradon_Ngay.Focus();
                        return false;
                    }
                }
            }
            if (bienphap == ENUM_ALD_BIENPHAPGQ.ALD_YCBoSungDon)
            {
                if (txtYCBS.Text.Length > 1000)
                {
                    lbtthongbao.Text = "Yêu cầu bổ sung không quá 1000 ký tự !";
                    txtYCBS.Focus();
                    return false;
                }
            }
            if (bienphap != ENUM_ALD_BIENPHAPGQ.ALD_ThuLy && bienphap != ENUM_ALD_BIENPHAPGQ.ALD_DonTrung)
            {

                //if (txtAnPhi.Text == "")
                //{
                //    lbtthongbao.Text = "Bạn cần nhập án phí !";
                //    txtAnPhi.Focus();
                //    return false;
                //}
                //if (txtTamUngAnPhi.Text == "")
                //{
                //    lbtthongbao.Text = "Bạn cần nhập tạm ứng án phí !";
                //    txtTamUngAnPhi.Focus();
                //    return false;
                //}
                //if (txtHanNopAnPhi.Text == "")
                //{
                //    lbtthongbao.Text = "Bạn chưa nhập hạn nộp án phí !";
                //    txtHanNopAnPhi.Focus();
                //    return false;
                //}
                if (String.IsNullOrEmpty(txtSothongbao.Text))
                {
                    String strMsg = "";
                    strMsg = "Chưa nhập Số Thông báo";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    txtSothongbao.Focus();
                    return false;
                }
                if (String.IsNullOrEmpty(txtNgaythongbao.Text))
                {
                    String strMsg = "";
                    strMsg = "Chưa nhập Ngày thông báo";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    txtNgaythongbao.Focus();
                    return false;
                }

            }
            if (txtLyDo.Text.Length > 500)
            {
                if (bienphap == ENUM_ALD_BIENPHAPGQ.ALD_TraLaiDon)
                {
                    lbtthongbao.Text = "Ghi chú không quá 500 ký tự !";
                }
                else
                {
                    lbtthongbao.Text = "Lý do không quá 500 ký tự !";
                }
                txtLyDo.Focus();
                return false;
            }

            return true;
        }
        protected void cmdCapNhat_Click(object sender, EventArgs e)
        {
            if (!CheckValid())
            {
                return;
            }
            String CurrUser = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            DateTime now = DateTime.Now;

            ALD_DON oDon = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();

            Decimal ToaAnNhanDonID = (Decimal)oDon.TOAANID;
            Decimal GiaiDoanDon = (Decimal)oDon.MAGIAIDOAN;

            //---------------------
            int DonXyLyID = 0;
            int DonChiTietID = 0;
            ALD_DON_XULY obj = new ALD_DON_XULY();
            decimal FileID = 0;
            string bienphap = dropBienPhapGQ.SelectedValue;
            decimal ToaAnCuEdit = 0;
            decimal duongSuID = Convert.ToDecimal(ddlDuongSu.SelectedValue);
            if (hddChiTietID.Value != "")
            {
                DonChiTietID = Convert.ToInt32(hddChiTietID.Value);
            }
            #region Update Bang Don_xuly
            if (hddCurrID.Value != "" && hddCurrID.Value != "0")
            {
                DonXyLyID = Convert.ToInt32(hddCurrID.Value);
                obj = dt.ALD_DON_XULY.Where(x => x.ID == DonXyLyID).FirstOrDefault();
                ToaAnCuEdit = obj.CDTN_TOAANID.Value;
                if (obj != null)
                {
                    if (obj.FILEID != null) FileID = (decimal)obj.FILEID;
                    obj.NGAYSUA = now;
                    obj.NGUOISUA = CurrUser;
                }
                else obj = new ALD_DON_XULY();
                if (obj.LOAIGIAIQUYET == 4 && bienphap != "4")
                {
                    ADS_DON_XULY_BL oBL = new ADS_DON_XULY_BL();
                    DataTable oYC = oBL.ALD_GETALL_DON_YCBS(DONID, obj.ID, 1, 5);
                    if (oYC.Rows.Count > 0) oBL.DEL_DON_YCBS_GETBYDONID(Convert.ToDecimal(oYC.Rows[0]["ID"].ToString()));
                }
            }
            else
            {

                //if (dt.ALD_DON_XULY.Where(x => x.DONID == DONID && x.LOAIGIAIQUYET == 5).ToList().Count > 0)
                //{
                //    lbtthongbao.Text = "Đơn đã được thụ lý, không được phép thêm mới !";
                //    return;
                //}
                //if (dt.ALD_DON_XULY.Where(x => x.DONID == DONID && x.LOAIGIAIQUYET == 3).ToList().Count > 0)
                //{
                //    lbtthongbao.Text = "Đơn đã trả lại, không được phép thêm mới !";
                //    return;
                //}
                obj = new ALD_DON_XULY();
                ALD_DON_BL oBL = new ALD_DON_BL();
                //obj.SOTHONGBAO = oBL.GETFILENEWTT(ToaAnNhanDonID, GiaiDoanDon, now.Year, 0).ToString();
                //Manhnd them kiem tra so Thong bao da co chua khi Them moi Thong bao
                if (txtSothongbao.Text != "")
                {
                    int vNam;
                    if (txtNgaythongbao.Text != "")
                    {
                        DateTime vdate = DateTime.Parse(txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); ;
                        vNam = vdate.Year;
                    }
                    else
                        vNam = DateTime.Now.Year;


                    decimal check = oBL.CHECKSTT_ALD((decimal)oDon.TOAANID, (decimal)oDon.MAGIAIDOAN, vNam, 0, Convert.ToDecimal(txtSothongbao.Text), ddlStbPhu.SelectedValue, obj.ID);
                    DateTime ngaythongbao = DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    String strMsg = "";
                    ALD_DON_BL oBL_STB = new ALD_DON_BL();
                    String STTNew = oBL_STB.GET_STB_XLDon_NEW_V2((decimal)oDon.TOAANID, "ALD", ngaythongbao).ToString();
                    if (check == 1)
                    {
                        strMsg = "Số thông báo " + txtSothongbao.Text + ddlStbPhu.SelectedValue + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        // txtSothongbao.Text = STTNew;
                        // ddlStbPhu.SelectedValue = "";
                        // txtSothongbao.Focus();
                        // return;
                    }
                    else
                    {
                        obj.SOTHONGBAO = txtSothongbao.Text;
                        obj.STB_PHU = ddlStbPhu.SelectedValue;
                    }
                }

            }
            obj.SOTHONGBAO = txtSothongbao.Text;
            obj.STB_PHU = ddlStbPhu.SelectedValue;
            obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            obj.LYDO = txtLyDo.Text.Trim();
            obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayGQ.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            if (DonChiTietID == 0)
            {
                obj.DONID = DONID;
            }
            else
            {
                obj.DON_CHITIETID = DonChiTietID;
                obj.DON_XULYID = DONID;
            }
            obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
            decimal rFileID = 0;
            switch (bienphap)
            {
                case ENUM_ALD_BIENPHAPGQ.ALD_ChuyenDonTrongNganh:
                    obj.CDTN_TOAANID = hddToaAn.Value == "" ? 0 : Convert.ToDecimal(hddToaAn.Value);
                    //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.CDTN_NGAYCHUYEN = now;
                    obj.TRADON_CANCUID = 0;
                    obj.CDNN_TENCQ = "";
                    rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO, obj.STB_PHU);
                    if (rFileID > 0) obj.FILEID = rFileID;
                    break;
                case ENUM_ALD_BIENPHAPGQ.ALD_ChuyenDonNgoaiNganh:
                    obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Text.Trim();
                    obj.CDTN_NGAYNHAN = DateTime.MinValue;
                    obj.CDTN_TOAANID = 0;
                    obj.TRADON_CANCUID = 0;
                    obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDNN_NgayChuyen.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    break;
                case ENUM_ALD_BIENPHAPGQ.ALD_TraLaiDon:
                    // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                    obj.CDTN_NGAYNHAN = DateTime.MinValue;
                    obj.CDTN_TOAANID = 0;
                    obj.CDNN_TENCQ = "";
                    obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtTradon_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon.SelectedValue);
                    rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO, obj.STB_PHU);
                    if (rFileID > 0) obj.FILEID = rFileID;
                    break;
                case ENUM_ALD_BIENPHAPGQ.ALD_YCBoSungDon:
                    obj.TRADON_CANCUID = 0;
                    obj.CDTN_NGAYNHAN = DateTime.MinValue;
                    obj.CDTN_TOAANID = 0;
                    obj.CDNN_TENCQ = "";
                    //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.YCBS_NOIDUNG = txtYCBS.Text;
                    obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Text.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Text.Trim());

                    rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO, obj.STB_PHU);
                    if (rFileID > 0) obj.FILEID = rFileID;
                    break;
                case ENUM_ALD_BIENPHAPGQ.ALD_DonTrung:
                    obj.TRADON_CANCUID = 0;
                    obj.CDTN_NGAYNHAN = DateTime.MinValue;
                    obj.CDTN_TOAANID = 0;
                    obj.CDNN_TENCQ = "";
                    break;
                default://Thụ lý
                    obj.TRADON_CANCUID = 0;
                    obj.CDTN_NGAYNHAN = DateTime.MinValue;
                    obj.CDTN_TOAANID = 0;
                    obj.CDNN_TENCQ = "";

                    //Cập nhật án phí
                    //if (chkNopAnPhi.Checked == false)
                    //{
                    DM_QHPL_TK qhpl_tk = dt.DM_QHPL_TK.Where(x => x.ID == oDon.QHPLTKID).FirstOrDefault();
                    if (qhpl_tk.OPTIONS == 1)
                    {
                        rFileID = UploadFileID(oDon, FileID, "05-VDS", obj.SOTHONGBAO, obj.STB_PHU);
                        if (rFileID > 0) obj.FILEID = rFileID;
                    }
                    else if (qhpl_tk.OPTIONS == 0)
                    {
                        rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO, obj.STB_PHU);
                        if (rFileID > 0) obj.FILEID = rFileID;
                    }
                    //}
                    break;
            }


            if (DonXyLyID == 0)
            {
                obj.NGAYTAO = obj.NGAYSUA = now;
                obj.NGUOISUA = obj.NGUOITAO = CurrUser;
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.ALD_DON_XULY.Add(obj);
            }
            dt.SaveChanges();
            //hddCurrID.Value = obj.ID.ToString();


            //Cập nhật thông tin án phí nếu thụ lý
            if (bienphap == ENUM_ALD_BIENPHAPGQ.ALD_ThuLy)
            {
                //List<ALD_ANPHI> lstAP = dt.ALD_ANPHI.Where(x => x.DONID == DONID).ToList();
                //ALD_ANPHI objAP = new ALD_ANPHI();
                //if (lstAP.Count > 0)
                //{
                //    objAP = lstAP[0];
                //    objAP.NGAYSUA = now;
                //    objAP.NGUOISUA = CurrUser;
                //}
                //else
                //{
                //    objAP.NGAYTAO = now;
                //    objAP.NGUOITAO = CurrUser;

                //}
                //objAP.DONID = DONID;
                //objAP.TINHTRANG = chkNopAnPhi.Checked == true ? 1 : 0;
                //objAP.GIATRITRANHCHAP = (String.IsNullOrEmpty(txtGiaTriTranhChap.Text.Trim())) ? 0 : Convert.ToDecimal(txtGiaTriTranhChap.Text.Trim(), cul);
                //objAP.MUCGIAMANPHI = (String.IsNullOrEmpty(txtMucGiamAnPhi.Text.Trim())) ? 0 : Convert.ToDecimal(txtMucGiamAnPhi.Text.Trim(), cul);
                //objAP.TAMUNGANPHI = (String.IsNullOrEmpty(txtTamUngAnPhi.Text.Trim())) ? 0 : Convert.ToDecimal(txtTamUngAnPhi.Text.Trim(), cul);

                //objAP.SONGAYGIAHAN = (String.IsNullOrEmpty(txtSoNgayGiaHan.Text.Trim())) ? 0 : Convert.ToDecimal(txtSoNgayGiaHan.Text.Trim());
                //objAP.HANNOP_SONGAY = (String.IsNullOrEmpty(txtHanNopAnPhi.Text.Trim())) ? 0 : Convert.ToInt32(this.txtHanNopAnPhi.Text.Trim());
                //if (lstAP.Count > 0)
                //{
                //    dt.SaveChanges();
                //}
                //else
                //{
                //    objAP.NGAYTAO = now;
                //    objAP.NGUOITAO = CurrUser;
                //    dt.ALD_ANPHI.Add(objAP);
                //    dt.SaveChanges();
                //}
                /////insert vào bảng DVCQG_THANH_TOAN
                //DVCQG_THANH_TOAN_BL obj_anphi = new DVCQG_THANH_TOAN_BL();
                //obj_anphi.DVCQG_THANH_TOAN_INSERT_ANPHI(2, DONID, obj.ID, objAP.ID, "3");

                ADS_DON_XULY_BL oBLYC = new ADS_DON_XULY_BL();
                DON_YEUCAU_BOSUNG objXuLy = new DON_YEUCAU_BOSUNG()
                {
                    ID = 0,
                    DONID = obj.DONID,
                    LOAIAN = 5,
                    DON_XULYID = obj.DON_XULYID,
                    LOAIGIAIQUYET = obj.LOAIGIAIQUYET,
                    NGAYGQ_YC = obj.NGAYGQ_YC,
                    LYDO = obj.LYDO,
                    CDTN_TOAANID = obj.CDTN_TOAANID,
                    CDTN_NGAYNHAN = obj.CDTN_NGAYNHAN,
                    CDNN_TENCQ = obj.CDNN_TENCQ,
                    TRADON_CANCUID = obj.TRADON_CANCUID,
                    NGAYTAO = obj.NGAYTAO,
                    NGUOITAO = obj.NGUOITAO,
                    NGAYSUA = obj.NGAYSUA,
                    NGUOISUA = obj.NGUOISUA,
                    CDNN_NGAYCHUYEN = obj.CDNN_NGAYCHUYEN,
                    TRADON_LYDOID = obj.TRADON_LYDOID,
                    TRADON_NGAYTRA = obj.TRADON_NGAYTRA,
                    YCBS_NGAYYEUCAU = obj.YCBS_NGAYYEUCAU,
                    YCBS_NOIDUNG = obj.YCBS_NOIDUNG,
                    CDTN_NGAYCHUYEN = obj.CDTN_NGAYCHUYEN,
                    SOTHONGBAO = obj.SOTHONGBAO,
                    FILEID = obj.FILEID,
                    YCBS_THOIHAN = obj.YCBS_THOIHAN,
                    TOAANID = obj.TOAANID,
                    NGAYTHONGBAO = obj.NGAYTHONGBAO,
                    DON_CHITIETID = obj.DON_CHITIETID,
                    DON_XULY_YCBS_ID = obj.ID,
                    STB_PHU = obj.STB_PHU
                };
                if (hddCurrID.Value == "" || hddCurrID.Value == "0")
                {
                    objXuLy.ID = 0;
                }
                else
                {
                    ADS_DON_XULY_BL oBL = new ADS_DON_XULY_BL();
                    DataTable oYC = oBL.ADS_GETALL_DON_YCBS(DONID, obj.ID, 1, 5);
                    if (oYC.Rows.Count > 0) objXuLy.ID = Convert.ToDecimal(oYC.Rows[0]["ID"].ToString());
                }
                oBLYC.DON_YCBS_INUP(objXuLy);
            }
            else if (bienphap == ENUM_ALD_BIENPHAPGQ.ALD_ChuyenDonTrongNganh)
            {
                //obj.CDTN_TOAANID
                //AHN_DON oDon = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
                oDon.LOAIDON = 2;
                dt.SaveChanges();
                //  ChuyenDonSangToaAnMoi(oDon, DonXyLyID, obj, ToaAnCuEdit);
                //Hủy session
                //decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                //QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                //if (oNSD != null)
                //{
                //    oNSD.IDANDANSU = 0;
                //    dt.SaveChanges();
                //    Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] = 0;
                //    UpdateTrangThaiDonKK();
                //    //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgXLDON", "Hoàn thành chuyển đơn đến tòa án khác, bạn hãy chọn đơn khác để xử lý tiếp !", Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx");                    
                //}
            }
            else if (bienphap == ENUM_ALD_BIENPHAPGQ.ALD_YCBoSungDon)
            {
                ADS_DON_XULY_BL oBLYC = new ADS_DON_XULY_BL();
                DON_YEUCAU_BOSUNG objXuLy = new DON_YEUCAU_BOSUNG()
                {
                    ID = 0,
                    DONID = obj.DONID,
                    LOAIAN = 5,
                    DON_XULYID = obj.DON_XULYID,
                    LOAIGIAIQUYET = obj.LOAIGIAIQUYET,
                    NGAYGQ_YC = obj.NGAYGQ_YC,
                    LYDO = obj.LYDO,
                    CDTN_TOAANID = obj.CDTN_TOAANID,
                    CDTN_NGAYNHAN = obj.CDTN_NGAYNHAN,
                    CDNN_TENCQ = obj.CDNN_TENCQ,
                    TRADON_CANCUID = obj.TRADON_CANCUID,
                    NGAYTAO = obj.NGAYTAO,
                    NGUOITAO = obj.NGUOITAO,
                    NGAYSUA = obj.NGAYSUA,
                    NGUOISUA = obj.NGUOISUA,
                    CDNN_NGAYCHUYEN = obj.CDNN_NGAYCHUYEN,
                    TRADON_LYDOID = obj.TRADON_LYDOID,
                    TRADON_NGAYTRA = obj.TRADON_NGAYTRA,
                    YCBS_NGAYYEUCAU = obj.YCBS_NGAYYEUCAU,
                    YCBS_NOIDUNG = obj.YCBS_NOIDUNG,
                    CDTN_NGAYCHUYEN = obj.CDTN_NGAYCHUYEN,
                    SOTHONGBAO = obj.SOTHONGBAO,
                    FILEID = obj.FILEID,
                    YCBS_THOIHAN = obj.YCBS_THOIHAN,
                    TOAANID = obj.TOAANID,
                    NGAYTHONGBAO = obj.NGAYTHONGBAO,
                    DON_CHITIETID = obj.DON_CHITIETID,
                    DON_XULY_YCBS_ID = obj.ID,
                    STB_PHU = obj.STB_PHU
                };
                if (hddCurrID.Value == "" || hddCurrID.Value == "0")
                {
                    objXuLy.ID = 0;
                }
                else
                {
                    ADS_DON_XULY_BL oBL = new ADS_DON_XULY_BL();
                    DataTable oYC = oBL.ALD_GETALL_DON_YCBS(DONID, obj.ID, 1, 5);
                    if (oYC.Rows.Count > 0) objXuLy.ID = Convert.ToDecimal(oYC.Rows[0]["ID"].ToString());
                }
                oBLYC.DON_YCBS_INUP(objXuLy);
            }
            else
            {
                //Hủy session
                //decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                //QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                //if (oNSD != null)
                //{
                //    oNSD.IDANDANSU = 0;
                //    dt.SaveChanges();
                //    Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] = 0;
                //    UpdateTrangThaiDonKK();
                //    Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgXLDON", "Hoàn thành giải quyết đơn, bạn hãy chọn đơn khác để xử lý tiếp !", Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx");
                //}
            }
            #endregion


            //------------------------------

            //cập nhật các đơn chi tiết có check chọn vào bảng đon xử lý



            UpdateTrangThaiDonKK();
            //-------------------------------------
            hddPageIndex.Value = "1";
            LoadGrid_XuLyDon();
            Resetcontrol();
            LoadDropDuongSu(DONID);
            //CheckQuyenAP(DONID);
            lbtthongbao.Text = "Lưu thành công!";
        }


        private void ChuyenDonSangToaAnMoi(ALD_DON oDon, decimal DonXyLyID, ALD_DON_XULY obj, decimal ToaAnCuEdit)
        {
            if (DonXyLyID == 0)
            {
                ALD_DON oDonMoi = new ALD_DON();

                //oDonMoi.MAVUVIEC = oDon.MAVUVIEC;//////
                oDonMoi.TENVUVIEC = oDon.TENVUVIEC;
                oDonMoi.SOTHUTU = oDon.SOTHUTU;
                oDonMoi.HINHTHUCNHANDON = oDon.HINHTHUCNHANDON;
                oDonMoi.NGAYVIETDON = oDon.NGAYVIETDON;
                oDonMoi.NGAYNHANDON = oDon.NGAYNHANDON;
                oDonMoi.LOAIQUANHE = oDon.LOAIQUANHE;
                oDonMoi.QUANHEPHAPLUATID = oDon.QUANHEPHAPLUATID;
                oDonMoi.YEUTONUOCNGOAI = oDon.YEUTONUOCNGOAI;
                oDonMoi.DONKIENCUANGUOIKHAC = oDon.DONKIENCUANGUOIKHAC;
                oDonMoi.USERTT_EMAIL = oDon.USERTT_EMAIL;
                oDonMoi.USERTT_ID = oDon.USERTT_ID;
                oDonMoi.USERTT_NGAYTAO = oDon.USERTT_NGAYTAO;
                oDonMoi.USERTT_NGAYGUI = oDon.USERTT_NGAYGUI;
                oDonMoi.USERTT_NGAYBOSUNG = oDon.USERTT_NGAYBOSUNG;
                oDonMoi.NGUOITAO = oDon.NGUOITAO;
                oDonMoi.NGAYTAO = oDon.NGAYTAO;
                oDonMoi.NGUOISUA = oDon.NGUOISUA;
                oDonMoi.NGAYSUA = oDon.NGAYSUA;
                //oDonMoi.TT = oDon.TT;
                oDonMoi.MAGIAIDOAN = oDon.MAGIAIDOAN;
                oDonMoi.NOIDUNGKHOIKIEN = oDon.NOIDUNGKHOIKIEN;
                oDonMoi.MABAOMAT = oDon.MABAOMAT;
                oDonMoi.TOAPHUCTHAMID = oDon.TOAPHUCTHAMID;
                oDonMoi.QHPLTKID = oDon.QHPLTKID;
                //oDonMoi.THONGTINTHEM = oDon.THONGTINTHEM;
                oDonMoi.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                oDonMoi.QUANHEPHAPLUAT_NAME = oDon.QUANHEPHAPLUAT_NAME;
                //oDonMoi.TENVUVIEC_PT = oDon.TENVUVIEC_PT;
                //mã vụ việc sinh ra thao tòa án mới
                ALD_DON_BL dsBL = new ALD_DON_BL();
                oDonMoi.TOAANID = obj.CDTN_TOAANID;
                DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oDonMoi.TOAANID.Value).FirstOrDefault();
                oDonMoi.TT = dsBL.GETNEWTT((decimal)oDonMoi.TOAANID);
                oDonMoi.MAVUVIEC = oTA.MA + "." + ENUM_LOAIVUVIEC.AN_LAODONG + "." + oDonMoi.TT.ToString();
                oDonMoi.CANBONHANDONID = 0;
                oDonMoi.THAMPHANKYNHANDON = 0;
                oDonMoi.LOAIDON = 1;
                oDonMoi.TRANGTHAI = 0;
                //lưu id đơn cũ khi chuyển đơn sang tòa án khác
                oDonMoi.DONID_TOACU = oDon.DONID_TOACU.HasValue ? oDon.DONID_TOACU.Value : oDon.ID;
                oDonMoi.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.ALD_DON.Add(oDonMoi);
                dt.SaveChanges();

                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GAIDOAN_INSERT_UPDATE("5", oDonMoi.ID, 2, obj.CDTN_TOAANID.Value, 0, 0, 0, 0);
                List<DuongSuTemp> lstDuongSuTemp = new List<DuongSuTemp>();

                //lấy danh sách đương sự
                IQueryable<ALD_DON_DUONGSU> lstoDS = dt.ALD_DON_DUONGSU.Where(s => s.DONID == oDon.ID);
                foreach (var item in lstoDS)
                {
                    ALD_DON_DUONGSU oDS = new ALD_DON_DUONGSU();
                    oDS.DONID = oDonMoi.ID;
                    oDS.MADUONGSU = item.MADUONGSU;
                    oDS.TENDUONGSU = item.TENDUONGSU;
                    oDS.ISDAIDIEN = item.ISDAIDIEN;
                    oDS.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
                    oDS.LOAIDUONGSU = item.LOAIDUONGSU;
                    oDS.SOCMND = item.SOCMND;
                    oDS.QUOCTICHID = item.QUOCTICHID;
                    oDS.TAMTRUID = item.TAMTRUID;
                    oDS.TAMTRUCHITIET = item.TAMTRUCHITIET;
                    oDS.HKTTID = item.HKTTID;
                    oDS.HKTTCHITIET = item.HKTTCHITIET;
                    oDS.NGAYSINH = item.NGAYSINH;
                    oDS.THANGSINH = item.THANGSINH;
                    oDS.NAMSINH = item.NAMSINH;
                    oDS.GIOITINH = item.GIOITINH;
                    oDS.NGUOIDAIDIEN = item.NGUOIDAIDIEN;
                    oDS.CHUCVU = item.CHUCVU;
                    oDS.NGUOITAO = item.NGUOITAO;
                    oDS.NGAYTAO = item.NGAYTAO;
                    oDS.NGUOISUA = item.NGUOISUA;
                    oDS.NGAYSUA = item.NGAYSUA;
                    oDS.NDD_DIACHIID = item.NDD_DIACHIID;
                    oDS.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
                    oDS.ISSOTHAM = item.ISSOTHAM;
                    oDS.ISPHUCTHAM = item.ISPHUCTHAM;
                    oDS.ISGDT = item.ISGDT;
                    oDS.ISDON = item.ISDON;
                    oDS.EMAIL = item.EMAIL;
                    oDS.DIENTHOAI = item.DIENTHOAI;
                    oDS.FAX = item.FAX;
                    oDS.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;
                    oDS.HKTTTINHID = item.HKTTTINHID;
                    oDS.TAMTRUTINHID = item.TAMTRUTINHID;
                    oDS.ISBVQLNGUOIKHAC = item.ISBVQLNGUOIKHAC;
                    oDS.TUOI = item.TUOI;
                    oDS.DIACHICOQUAN = item.DIACHICOQUAN;
                    oDS.ID_DUONGSU_TACC = item.ID_DUONGSU_TACC;
                    oDS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ALD_DON_DUONGSU.Add(oDS);
                    dt.SaveChanges();

                    lstDuongSuTemp.Add(new DuongSuTemp(item.ID, oDS.ID));
                }


                //lấy danh sách người tham gia tố tụng
                IQueryable<ALD_DON_THAMGIATOTUNG> lstoTT = dt.ALD_DON_THAMGIATOTUNG.Where(s => s.DONID == oDon.ID);
                foreach (var item in lstoTT)
                {
                    //lưu thông tin người tham gia tố tụng
                    ALD_DON_THAMGIATOTUNG oTT = new ALD_DON_THAMGIATOTUNG();
                    oTT.DONID = oDonMoi.ID;
                    oTT.HOTEN = item.HOTEN;
                    oTT.TAMTRUID = item.TAMTRUID;
                    oTT.TAMTRUCHITIET = item.TAMTRUCHITIET;
                    oTT.HKTTID = item.HKTTID;
                    oTT.HKTTCHITIET = item.HKTTCHITIET;
                    oTT.NGAYSINH = item.NGAYSINH;
                    oTT.THANGSINH = item.THANGSINH;
                    oTT.NAMSINH = item.NAMSINH;
                    oTT.GIOITINH = item.GIOITINH;
                    oTT.TUCACHTGTTID = item.TUCACHTGTTID;
                    oTT.NGUOIDAIDIEN = item.NGUOIDAIDIEN;
                    oTT.CHUCVU = item.CHUCVU;
                    oTT.NGAYTHAMGIA = item.NGAYTHAMGIA;
                    oTT.NGAYKETTHUC = item.NGAYKETTHUC;
                    oTT.NGAYTAO = item.NGAYTAO;
                    oTT.NGUOITAO = item.NGUOITAO;
                    oTT.NGAYSUA = item.NGAYSUA;
                    oTT.NGUOISUA = item.NGUOISUA;
                    oTT.EMAIL = item.EMAIL;
                    oTT.DIENTHOAI = item.DIENTHOAI;
                    oTT.FAX = item.FAX;
                    oTT.HKTTTINHID = item.HKTTTINHID;
                    oTT.TAMTRUTINHID = item.TAMTRUTINHID;
                    oTT.ID_DUONGSU_TACC = item.ID_DUONGSU_TACC;
                    UpdateDuongSuIdTGTT(item, oTT, lstDuongSuTemp);
                    //oTT.DUONGSUID = item.DUONGSUID;
                    oTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ALD_DON_THAMGIATOTUNG.Add(oTT);
                    dt.SaveChanges();
                }


                IQueryable<ALD_DON_TAILIEU> lstTailieu = dt.ALD_DON_TAILIEU.Where(s => s.DONID == oDon.ID);
                foreach (var item in lstTailieu)
                {
                    ALD_DON_TAILIEU objtl = new ALD_DON_TAILIEU();
                    objtl.DONID = oDonMoi.ID;
                    objtl.TENTAILIEU = item.TENTAILIEU;
                    objtl.TENFILE = item.TENFILE;
                    objtl.LOAIFILE = item.LOAIFILE;
                    objtl.NOIDUNG = item.NOIDUNG;
                    objtl.NGUOITAO = item.NGUOITAO;
                    objtl.NGAYTAO = item.NGAYTAO;
                    objtl.NGUOISUA = item.NGUOISUA;
                    objtl.NGAYSUA = item.NGAYSUA;
                    objtl.BANGIAOID = item.BANGIAOID;
                    objtl.NGAYBANGIAO = item.NGAYBANGIAO;
                    objtl.NGUOIBANGIAO = item.NGUOIBANGIAO;
                    objtl.LOAIDOITUONG = item.LOAIDOITUONG;
                    objtl.NGUOINHANID = item.NGUOINHANID;
                    objtl.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ALD_DON_TAILIEU.Add(objtl);
                    dt.SaveChanges();
                }
            }
            else
            {
                ///
                //kiểm tra tòa án mới xem có sửa hay không, nếu có thì thay dổi, không thì thôi
                ALD_DON oDonNew = dt.ALD_DON.FirstOrDefault(s => s.DONID_TOACU == obj.DONID && s.TOAANID == ToaAnCuEdit);
                if (oDonNew != null)
                {
                    if (oDonNew.TOAANID.Value != obj.CDTN_TOAANID)
                    {
                        //cập nhật lại thông tin tòa án
                        ALD_DON_BL dsBL = new ALD_DON_BL();
                        oDonNew.TOAANID = obj.CDTN_TOAANID;
                        DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oDonNew.TOAANID.Value).FirstOrDefault();
                        oDonNew.TT = dsBL.GETNEWTT((decimal)oDonNew.TOAANID);
                        oDonNew.MAVUVIEC = oTA.MA + "." + ENUM_LOAIVUVIEC.AN_LAODONG + "." + oDonNew.TT.ToString();
                        dt.SaveChanges();

                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        GD.GAIDOAN_UPDATE("3", oDonNew.ID, 2, Convert.ToDecimal(oDonNew.TOAANID), 0, 0, 0, 0);
                    }
                }

            }
        }

        private void DeleteDonChuyenToaAnKhac(ALD_DON_XULY obj)
        {
            ALD_DON oDon = dt.ALD_DON.FirstOrDefault(s => s.DONID_TOACU == obj.DONID && s.TOAANID == obj.CDTN_TOAANID);
            if (oDon != null)
            {
                if (dt.ALD_DON_THAMGIATOTUNG.Count(s => s.DONID == oDon.ID) > 0)
                {
                    List<ALD_DON_THAMGIATOTUNG> lstTGTT = dt.ALD_DON_THAMGIATOTUNG.Where(s => s.DONID == oDon.ID).ToList();
                    dt.ALD_DON_THAMGIATOTUNG.RemoveRange(lstTGTT);
                }
                if (dt.ALD_DON_TAILIEU.Count(s => s.DONID == oDon.ID) > 0)
                {
                    List<ALD_DON_TAILIEU> lstTGTT = dt.ALD_DON_TAILIEU.Where(s => s.DONID == oDon.ID).ToList();
                    dt.ALD_DON_TAILIEU.RemoveRange(lstTGTT);
                }
                List<ALD_DON_DUONGSU> lstDS = dt.ALD_DON_DUONGSU.Where(s => s.DONID == oDon.ID).ToList();
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GIAIDOAN_DELETES("5", oDon.ID, 2);

                dt.ALD_DON.Remove(oDon);
                dt.ALD_DON_DUONGSU.RemoveRange(lstDS);
                dt.SaveChanges();
            }


        }

        private void UpdateDuongSuIdTGTT(ALD_DON_THAMGIATOTUNG oTTOLD, ALD_DON_THAMGIATOTUNG oTTNEW, List<DuongSuTemp> lstDuongSuTemp)
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
        void UpdateTrangThaiDonKK()
        {
            int bienphap_gd = Convert.ToInt16(dropBienPhapGQ.SelectedValue);
            string loai_an = ENUM_LOAIAN.AN_LAODONG + "";
            decimal vuviecid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
            string yeucau = "";
            switch (bienphap_gd)
            {
                case 1:
                    //chuyen don trong he thong
                    yeucau = txtToaAn.Text.Trim();
                    break;
                case 3:
                    //tra lai don
                    yeucau = ddlLyTradon.SelectedItem.Text;
                    break;
                case 4:
                    //yeu cau bo sung
                    yeucau = txtYCBS.Text.Trim();
                    break;
            }
            try
            {
                DAL.DKK.DKKContextContainer dkk_dt = new DAL.DKK.DKKContextContainer();
                BL.DonKK.DONKK_DON_BL objDonKK = new BL.DonKK.DONKK_DON_BL();
                objDonKK.UpdateTrangThaiDonKK(bienphap_gd, yeucau, loai_an, vuviecid);
            }
            catch (Exception ex) { }
        }

        protected void chkNopAnPhi_CheckedChanged(object sender, EventArgs e)
        {
            SetEnableZoneNopAnPhi(chkNopAnPhi.Checked);
            Cls_Comon.SetFocus(this, this.GetType(), chkNopAnPhi.ClientID);
        }
        void SetEnableZoneNopAnPhi(bool status)
        {
            txtGiaTriTranhChap.Enabled = txtMucGiamAnPhi.Enabled = txtTamUngAnPhi.Enabled = txtHanNopAnPhi.Enabled = txtSoNgayGiaHan.Enabled = txtNgaythongbaoAP.Enabled = txtSothongbaoAP.Enabled = status == true ? false : true;
            if (status)
                txtGiaTriTranhChap.Text = txtMucGiamAnPhi.Text = txtTamUngAnPhi.Text = txtHanNopAnPhi.Text = txtSoNgayGiaHan.Text = txtNgaythongbaoAP.Text = txtSothongbaoAP.Text = "";
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
            decimal FileID = Convert.ToDecimal(hddFileid.Value);
            ALD_FILE oND = dt.ALD_FILE.Where(x => x.ID == FileID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }
        protected void txtGiaTriTranhChap_TextChanged(object sender, EventArgs e)
        {
            TinhTamUngAnPhi();
        }

        protected void txtMucGiamAnPhi_TextChanged(object sender, EventArgs e)
        {
            TinhTamUngAnPhi();
        }

        //protected void TinhTamUngAnPhi()
        //{
        //    lbtthongbao.Text = "";
        //    decimal txtGTTC = (String.IsNullOrEmpty(txtGiaTriTranhChap.Text.Trim())) ? 0 : Convert.ToDecimal(txtGiaTriTranhChap.Text.Trim(), cul);
        //    decimal txtMGAP = (String.IsNullOrEmpty(txtMucGiamAnPhi.Text.Trim())) ? 0 : Convert.ToDecimal(txtMucGiamAnPhi.Text.Trim(), cul);
        //    decimal txtTamUng = 0;
        //    if (txtGTTC == 0)
        //    {
        //        txtTamUng = (String.IsNullOrEmpty(txtTamUngAnPhi.Text.Trim())) ? 0 : Convert.ToDecimal(txtTamUngAnPhi.Text.Trim(), cul); ;
        //    }
        //    else if (txtGTTC <= 12000000)
        //    {
        //        txtTamUng = 300000;
        //    }
        //    else if (txtGTTC <= 400000000)
        //    {
        //        txtTamUng = txtGTTC * 5 / 200;
        //    }
        //    else if (txtGTTC <= 800000000)
        //    {
        //        txtTamUng = 10000000 + (txtGTTC - 400000000) * 4 / 200;
        //    }
        //    else if (txtGTTC <= 2000000000)
        //    {
        //        txtTamUng = 18000000 + (txtGTTC - 800000000) * 3 / 200;
        //    }
        //    else if (txtGTTC <= 4000000000)
        //    {
        //        txtTamUng = 36000000 + (txtGTTC - 2000000000) * 2 / 200;
        //    }
        //    else
        //    {
        //        txtTamUng = 56000000 + (txtGTTC - 4000000000) / 2000;
        //    }
        //    if (txtTamUng < txtMGAP) { lbThongbaoAP.Text = "Mức giảm án phí phải nhỏ hơn tiền tạm ứng."; txtMucGiamAnPhi.Focus(); return; }
        //    txtTamUngAnPhi.Text = string.Format("{0:0,000}", (txtTamUng - txtMGAP)).Replace(',', '.');
        //}

        protected void TinhTamUngAnPhi()
        {
            lbtthongbao.Text = "";
            lbThongbaoAP.Text = "";

            decimal txtGTTC = (String.IsNullOrEmpty(txtGiaTriTranhChap.Text.Trim())) ? 0 : Convert.ToDecimal(txtGiaTriTranhChap.Text.Trim(), cul);
            decimal txtMGAP = (String.IsNullOrEmpty(txtMucGiamAnPhi.Text.Trim())) ? 0 : Convert.ToDecimal(txtMucGiamAnPhi.Text.Trim(), cul);
            decimal txtTamUng = 0;

            if (txtGTTC <= 6000000)
            {
                txtTamUng = 300000;
            }
            else if (txtGTTC <= 400000000)
            {
                txtTamUng = txtGTTC * 3 / 100;
                if (txtTamUng < 300000)
                    txtTamUng = 300000;
            }
            else if (txtGTTC <= 2000000000)
            {
                txtTamUng = 12000000 + (txtGTTC - 400000000) * 2 / 100;
            }
            else
            {
                txtTamUng = 44000000 + (txtGTTC - 2000000000) * 1 / 1000; // 0,1%
            }

            if (txtTamUng < txtMGAP)
            {
                lbThongbaoAP.Text = "Mức giảm án phí phải nhỏ hơn tiền tạm ứng.";
                txtMucGiamAnPhi.Focus();
                return;
            }

            txtTamUngAnPhi.Text = string.Format("{0:0,000}", (txtTamUng - txtMGAP)).Replace(',', '.');
        }

        protected void rptAP_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("lblDownloadAP"));
            decimal CurrID = Convert.ToDecimal(e.CommandArgument.ToString());
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
                    hddCurrAPID.Value = CurrID.ToString();
                    LoadInfo_AnPhi(CurrID);
                    break;
                case "XoaAP":
                    try
                    {
                        DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                        decimal _check_out = 0;
                        obj.CHECK_DELETE_ANPHI(CurrID, "5", ref _check_out);
                        if (_check_out == 1)
                        {
                            ALD_ANPHI objAP = dt.ALD_ANPHI.Where(x => x.ID == CurrID).FirstOrDefault();
                            ALD_TONGDAT oTD = dt.ALD_TONGDAT.Where(x => x.DONID == objAP.DONID).FirstOrDefault();
                            DON_MIENANPHI_BL dON = new DON_MIENANPHI_BL();
                            DataTable dataTable = dON.GET_DON_MIENANPHI_BY_ANPHI_ID(objAP.ID, 5);
                            ALD_TONGDAT_BL dS_TONGDAT_BL = new ALD_TONGDAT_BL();

                            if (oTD != null && objAP.TINHTRANG != 1 && dataTable.Rows.Count == 0)
                            {
                                lbThongbaoAP.Text = "Bạn không thể xóa khi đã tống đạt!";
                                return;
                            }
                            else if ((objAP.TINHTRANG == 1 || dataTable.Rows.Count > 0)
                                && dS_TONGDAT_BL.ALD_TONGDATDOITUONG_ANPHI_GETBYANPHIID_TONGDATID(objAP.DONID, objAP.ID).Rows.Count > 0)

                            {
                                lbThongbaoAP.Text = "Bạn không thể xóa khi đã tống đạt!";
                                return;
                            }
                            else
                            {
                                //anhpn add log án phí 08/01/2025
                                string CONTENT_JSON = null;
                                string CONTENT_JSON_OLD = JsonConvert.SerializeObject(objAP, Formatting.Indented);
                                string MATHONGBAO = "";
                                var DVCQG_THANH_TOAN = DataExtensions.GetAllWithClause<BL.GSTP.BANGSETGET.DVCQG_THANH_TOAN>("ANPHI_ID = " + CurrID + " AND MALOAIVUVIEC = '5'");
                                if (DVCQG_THANH_TOAN.Count() > 0)
                                {
                                    MATHONGBAO = DVCQG_THANH_TOAN.FirstOrDefault().MA_THONGBAO;
                                }
                                LOG_THONGTINANPHI_QLTA log = new LOG_THONGTINANPHI_QLTA();
                                log.InsertLog(Session[ENUM_LOAIAN.AN_LAODONG].ToString(), CurrID.ToString(), MATHONGBAO, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Delete", CONTENT_JSON, CONTENT_JSON_OLD);

                                dt.ALD_ANPHI.Remove(objAP);
                                dt.SaveChanges();
                                lbThongbaoAP.Text = "Xóa thành công!";
                                //DELETE DVCQG_THANH_TOAN-------------
                                decimal _VALUE = 0;
                                obj.DVCQG_THANH_TOAN_DELETE_ANPHI(CurrID, "5", ref _VALUE);
                            }

                        }
                        else
                        {
                            lbThongbaoAP.Text = "Đã thanh toán hoặc đã tống đạt nên không thể xóa!";
                        }
                        //-------------
                        LoadGrid_AnPhi();
                        LoadGrid_XuLyDon();
                    }
                    catch (Exception ex) { lbThongbaoAP.Text = ex.Message; }
                    break;
                case "LSTBAnPhi":
                    try
                    {
                        CurrID = Convert.ToDecimal(e.CommandArgument.ToString());
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv();");
                        string linkPop = "/QLAN/ALD/XuLyDon/Popup/pMienAnPhi.aspx?ID=" + CurrID;
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(950/2); var Mtop = (screen.height/2)-(600/2); javascript:window.open('" + linkPop + "', '_blank', 'height=600px,width=950px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=no,scrollbars=0'); ", true);
                    }
                    catch (Exception ex) { lbThongbaoAP.Text = ex.Message; }
                    break;
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

        void LoadInfo_AnPhi(Decimal CurrID)
        {
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);

            List<ALD_ANPHI> lst = dt.ALD_ANPHI.Where(x => x.ID == CurrID).ToList<ALD_ANPHI>();
            if (lst != null && lst.Count > 0)
            {
                ALD_ANPHI obj = lst[0];
                if (obj.TINHTRANG == 1)
                    chkNopAnPhi.Checked = true;
                else
                    chkNopAnPhi.Checked = false;
                //chkNopAnPhi.Enabled = false;
                SetEnableZoneNopAnPhi(chkNopAnPhi.Checked);
                if (obj.DUONGSU_ID != null)
                {
                    ddlDuongSu.SelectedValue = obj.DUONGSU_ID + "";
                }
                else ddlDuongSu.SelectedValue = "0";
                txtGiaTriTranhChap.Text = (String.IsNullOrEmpty(obj.GIATRITRANHCHAP + "")) ? "" : ((decimal)obj.GIATRITRANHCHAP).ToString("#,0.###", cul);
                txtMucGiamAnPhi.Text = (String.IsNullOrEmpty(obj.MUCGIAMANPHI + "")) ? "" : ((decimal)obj.MUCGIAMANPHI).ToString("#,0.###", cul);
                txtTamUngAnPhi.Text = (String.IsNullOrEmpty(obj.TAMUNGANPHI + "")) ? "" : ((decimal)obj.TAMUNGANPHI).ToString("#,0.###", cul);
                txtHanNopAnPhi.Text = obj.HANNOP_SONGAY + "";
                txtSoNgayGiaHan.Text = (String.IsNullOrEmpty(obj.SONGAYGIAHAN + "")) ? "" : ((decimal)obj.SONGAYGIAHAN).ToString("#,0.###", cul);
                txtSothongbaoAP.Text = obj.SOTHONGBAO + "";
                //txtSothongbaoAP.Enabled = false;
                txtNgaythongbaoAP.Text = (obj.NGAYTHONGBAO == null) ? "" : ((DateTime)obj.NGAYTHONGBAO).ToString("dd/MM/yyyy", cul);
            }
        }

        protected void rptAP_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("lblDownloadAP"));
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lblSuaAP = (LinkButton)e.Item.FindControl("lblSuaAP");
                Cls_Comon.SetLinkButton(lblSuaAP, oPer.CAPNHAT);

                LinkButton lbtXoaAP = (LinkButton)e.Item.FindControl("lbtXoaAP");
                Cls_Comon.SetLinkButton(lbtXoaAP, oPer.XOA);

                LinkButton lbtLSTBAnPhi = (LinkButton)e.Item.FindControl("lbtLSTBAnPhi");
                string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();

                decimal vAPID = Convert.ToDecimal(rowView.Row[1]);

                DAL.GSTP.DVCQG_THANH_TOAN oAP = dt.DVCQG_THANH_TOAN.Where(x => x.ANPHI_ID == vAPID && x.MALOAIVUVIEC == "5").FirstOrDefault();
                ALD_SOTHAM_THULY oTLST = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();

                // Kiểm tra xem đơn đã được trả lại (LOAIGIAIQUYET == 3) hay chưa
                bool isDonTraLai = dt.ALD_DON_XULY.Any(x => x.DONID == DONID && x.LOAIGIAIQUYET == 3);

                DON_MIENANPHI_BL dON_MIENANPHI_BL = new DON_MIENANPHI_BL();
                DataTable dataTable = dON_MIENANPHI_BL.GET_DON_MIENANPHI_BY_ANPHI_ID(vAPID, 5);

                ALD_ANPHI aDS_ANPHI = dt.ALD_ANPHI.Where(x => x.ID == vAPID).FirstOrDefault();

                if ((dataTable == null || dataTable.Rows.Count == 0) && aDS_ANPHI.TINHTRANG == 0)
                {
                    lblSuaAP.Visible = lbtXoaAP.Visible = true;
                    lbtLSTBAnPhi.Text = "Miễn án phí";
                }
                else
                {
                    lblSuaAP.Visible = lbtXoaAP.Visible = false;
                    lbtLSTBAnPhi.Text = "Lịch sử TBAP";
                }

                /*1. Nếu vụ án đang trong giai đoạn phúc thẩm thì không được xóa
                  2. Nếu vụ án đã có thụ lý sơ thẩm thì không được xóa
                  3. Nếu vụ án đã có biên lai án phí thì không được sửa và xóa*/
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oTLST != null || isDonTraLai)
                {
                    lblSuaAP.Visible = lbtXoaAP.Visible = false;
                }
                else if ((oAP != null && oAP.TRANGTHAITHANHTOAN == 1) || (dataTable.Rows.Count > 0 || aDS_ANPHI.TINHTRANG == 1))
                {
                    lblSuaAP.Visible = lbtXoaAP.Visible = false;
                }
                else
                {
                    lblSuaAP.Visible = lbtXoaAP.Visible = true;
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

                string toagiaiquyetID = rowView.Row["TOA_GIAIQUYET_ID"].ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!String.IsNullOrEmpty(toagiaiquyetID) && !toagiaiquyetID.Equals(donviID))
                {
                    lblSuaAP.Visible = false;
                    lbtXoaAP.Visible = false;

                }
                //check vụ án đã kết thúc không cho sửa xóa
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lbtthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                    Cls_Comon.SetButton(cmdCapNhat, false);
                    Cls_Comon.SetButton(cmdCapNhatAP, false);
                    Cls_Comon.SetButton(cmdThemmoiAP, false);
                    lbtLSTBAnPhi.Visible = false;
                    lbtXoaAP.Visible = false;
                    lblSuaAP.Visible = false;

                }
            }
        }

        #region phân trang
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
        #endregion

        protected void btnThemmoiAP_Click(object sender, EventArgs e)
        {
            ResetcontrolAP();
        }

        protected void cmdCapNhatAP_Click(object sender, EventArgs e)
        {
            if (!CheckValidAP())
            {
                return;
            }
            try
            {
                string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                decimal? DONID = Convert.ToDecimal(current_id);
                int APId = 0;
                if (hddCurrAPID.Value != "" && hddCurrAPID.Value != "0")
                {
                    APId = Convert.ToInt32(hddCurrAPID.Value);
                }

                //-------Update bang an phi------------
                ALD_ANPHI objAP = new ALD_ANPHI();
                #region Update bang an phi
                try
                {
                    string CONTENT_JSON = "";
                    string CONTENT_JSON_OLD = "";
                    try
                    {
                        objAP = dt.ALD_ANPHI.Where(x => x.ID == APId).FirstOrDefault();
                        if (APId != 0)
                        {
                            objAP.NGAYSUA = DateTime.Now;
                            objAP.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                            // Chuyển đối tượng thành chuỗi JSON
                            CONTENT_JSON_OLD = JsonConvert.SerializeObject(objAP, Formatting.Indented);
                        }
                        else
                        {
                            objAP = new ALD_ANPHI();
                            CONTENT_JSON_OLD = null;
                        }
                    }
                    catch (Exception ex) { objAP = new ALD_ANPHI(); }
                    objAP.DONID = DONID;
                    objAP.TINHTRANG = chkNopAnPhi.Checked == true ? 1 : 0;
                    objAP.GIATRITRANHCHAP = (String.IsNullOrEmpty(txtGiaTriTranhChap.Text.Trim())) ? 0 : Convert.ToDecimal(txtGiaTriTranhChap.Text.Trim(), cul);
                    objAP.MUCGIAMANPHI = (String.IsNullOrEmpty(txtMucGiamAnPhi.Text.Trim())) ? 0 : Convert.ToDecimal(txtMucGiamAnPhi.Text.Trim(), cul);
                    objAP.TAMUNGANPHI = (String.IsNullOrEmpty(txtTamUngAnPhi.Text.Trim())) ? 0 : Convert.ToDecimal(txtTamUngAnPhi.Text.Trim(), cul);
                    objAP.DUONGSU_ID = Convert.ToDecimal(ddlDuongSu.SelectedValue);
                    objAP.DUONGSU_IDS = ddlDuongSu.SelectedValue + "";
                    objAP.SONGAYGIAHAN = (String.IsNullOrEmpty(txtSoNgayGiaHan.Text.Trim())) ? 0 : Convert.ToDecimal(txtSoNgayGiaHan.Text.Trim());
                    objAP.HANNOP_SONGAY = (String.IsNullOrEmpty(txtHanNopAnPhi.Text.Trim())) ? 0 : Convert.ToInt32(txtHanNopAnPhi.Text);
                    objAP.SOTHONGBAO = txtSothongbaoAP.Text;
                    objAP.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbaoAP.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythongbaoAP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (APId == 0)
                    {
                        objAP.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        objAP.NGAYTAO = objAP.NGAYSUA = DateTime.Now;
                        objAP.NGUOISUA = objAP.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        objAP.MAGIAIDOAN = 2;//anhvh add test 09/12/2021
                        dt.ALD_ANPHI.Add(objAP);
                    }
                    else
                    {
                        objAP.NGAYSUA = DateTime.Now;
                        objAP.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    dt.SaveChanges();

                    hddCurrAPID.Value = objAP.ID.ToString();
                    ///insert vào bảng DVCQG_THANH_TOAN
                    if (APId == 0 && objAP.TINHTRANG == 0)
                    {
                        decimal donID = Convert.ToDecimal(current_id);
                        ALD_DON_XULY donXL = dt.ALD_DON_XULY.Where(x => (x.DONID == DONID || x.DON_XULYID == DONID) && x.LOAIGIAIQUYET == 5).FirstOrDefault();
                        DVCQG_THANH_TOAN_BL obj_anphi = new DVCQG_THANH_TOAN_BL();
                        obj_anphi.DVCQG_THANH_TOAN_INSERT_ANPHI(2, donID, donXL.ID, objAP.ID, "5", Convert.ToString(objAP.DUONGSU_ID));
                    }
                    else if (APId != 0)
                    {
                        ///UPDATE vào bảng DVCQG_THANH_TOAN
                        DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                        obj.DVCQG_THANH_TOAN_UP_ANPHI(objAP.ID, "5");
                    }
                    //anhpn add log án phí 08/01/2025
                    string MATHONGBAO = "";
                    var DVCQG_THANH_TOAN = DataExtensions.GetAllWithClause<BL.GSTP.BANGSETGET.DVCQG_THANH_TOAN>("ANPHI_ID = " + objAP.ID + " AND MALOAIVUVIEC = '5'");
                    if (DVCQG_THANH_TOAN.Count() > 0)
                    {
                        MATHONGBAO = DVCQG_THANH_TOAN.FirstOrDefault().MA_THONGBAO;
                    }
                    if (APId == 0)
                    {
                        CONTENT_JSON = JsonConvert.SerializeObject(objAP, Formatting.Indented);
                        LOG_THONGTINANPHI_QLTA log = new LOG_THONGTINANPHI_QLTA();
                        log.InsertLog(DONID.ToString(), objAP.ID.ToString(), MATHONGBAO, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Insert", CONTENT_JSON, CONTENT_JSON_OLD);
                    }
                    else
                    {
                        CONTENT_JSON = JsonConvert.SerializeObject(objAP, Formatting.Indented);
                        LOG_THONGTINANPHI_QLTA log = new LOG_THONGTINANPHI_QLTA();
                        log.InsertLog(DONID.ToString(), objAP.ID.ToString(), MATHONGBAO, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Update", CONTENT_JSON, CONTENT_JSON_OLD);
                    }
                    if (chkNopAnPhi.Checked == false)
                    {
                        //check lại xem đã tồn tại trong bảng DVCQG_THANH_TOAN chưa nếu chưa thì insert
                        //dropBienPhapGQ.Items.Add(new ListItem("Thụ lý vụ việc", ENUM_ALD_BIENPHAPGQ.ADS_ThuLy));    
                        //LOAIGIAIQUYET == 5 
                        DVCQG_THANH_TOAN_BL obj_anphiS = new DVCQG_THANH_TOAN_BL();
                        decimal donIDS = Convert.ToDecimal(current_id);
                        ALD_DON_XULY donXLS = dt.ALD_DON_XULY.Where(x => (x.DONID == DONID || x.DON_XULYID == DONID) && x.LOAIGIAIQUYET == 5).FirstOrDefault();
                        if (donXLS.LOAIGIAIQUYET == 5)
                        {
                            DataTable oDT = obj_anphiS.CHECK_THANH_TOAN_IN_ANPHI(2, donIDS, donXLS.ID, objAP.ID, "5", objAP.DUONGSU_ID + "");
                            if (oDT.Rows.Count == 0)
                            {
                                obj_anphiS.DVCQG_THANH_TOAN_INSERT_ANPHI(2, donIDS, donXLS.ID, objAP.ID, "5", objAP.DUONGSU_ID + "");
                            }
                        }
                    }
                    else
                    {
                        // VNPT biểu mẫu in miễn án phí
                        ALD_DON aDS_DON = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                        DM_BIEUMAU bmMienAnPhi = dt.DM_BIEUMAU.Where(x => x.MABM == "100-DS").FirstOrDefault();
                        ALD_FILE objFile = dt.ALD_FILE.Where(x => x.DONID == DONID && x.BIEUMAUID == bmMienAnPhi.ID).FirstOrDefault();
                        if (objFile != null)
                        {
                            var rFileID = UploadFileID(aDS_DON, objFile.ID, "100-DS", objAP.SOTHONGBAO, objAP.STB_PHU);
                            if (rFileID > 0) objAP.FILEID = rFileID;
                            dt.SaveChanges();
                        }
                        else
                        {
                            var rFileID = UploadFileID(aDS_DON, 0, "100-DS", objAP.SOTHONGBAO, objAP.STB_PHU);
                            if (rFileID > 0) objAP.FILEID = rFileID;
                            dt.SaveChanges();
                        }
                    }

                }
                catch (Exception ex) { }
                #endregion

                //-------------------------------------
                hddPageIndexAP.Value = "1";
                LoadGrid_AnPhi();
                LoadGrid_XuLyDon();
                ResetcontrolAP();
                Cls_Comon.SetButton(cmdCapNhatAP, true);
                Cls_Comon.SetButton(cmdThemmoiAP, true);
                string strMsg = "Lưu thành công!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
            }
            catch (Exception ex) { lbThongbaoAP.Text = ex.Message; }
        }

        private bool CheckValidAP()
        {
            if (ddlDuongSu.SelectedValue == "0")
            {
                string strMsg = "Bạn chưa chọn đương sự!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                ddlDuongSu.Focus();
                return false;
            }
            else
            {
                decimal dsID = Convert.ToDecimal(ddlDuongSu.SelectedValue);
                decimal APId = 0;
                if (hddCurrAPID.Value != "" && hddCurrAPID.Value != "0")
                {
                    APId = Convert.ToDecimal(hddCurrAPID.Value);

                    ALD_ANPHI objAP = dt.ALD_ANPHI.Where(x => x.ID == APId).FirstOrDefault();
                    ALD_TONGDAT oTD = dt.ALD_TONGDAT.Where(x => x.DONID == objAP.DONID).FirstOrDefault();
                    DON_MIENANPHI_BL dON = new DON_MIENANPHI_BL();
                    DataTable dataTable = dON.GET_DON_MIENANPHI_BY_ANPHI_ID(objAP.ID, 5);

                    if (oTD != null && objAP.TINHTRANG != 1 && dataTable.Rows.Count == 0)
                    {
                        lbThongbaoAP.Text = "Bạn không thể lưu khi đã tống đạt!";
                        return false;
                    }
                    else if ((objAP.TINHTRANG == 1 || dataTable.Rows.Count > 0))
                    {
                        ALD_TONGDAT_BL dS_TONGDAT_BL = new ALD_TONGDAT_BL();
                        DataTable anphiTable = dS_TONGDAT_BL.ALD_TONGDATDOITUONG_ANPHI_GETBYANPHIID_TONGDATID(objAP.DONID, objAP.ID);
                        if (anphiTable.Rows.Count > 0)
                        {
                            lbThongbaoAP.Text = "Bạn không thể lưu khi đã tống đạt!";
                            return false;
                        }
                    }

                }
                ALD_ANPHI ap = dt.ALD_ANPHI.Where(x => x.DUONGSU_ID == dsID && x.ID != APId && APId != 0).FirstOrDefault();
                if (ap != null)
                {
                    string strMsg = "Đương sự này đã có thông tin biên lai án phí. Bạn hãy chọn đương sự khác!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    ddlDuongSu.Focus();
                    return false;
                }
            }
            if (chkNopAnPhi.Checked == false)
            {
                if (txtTamUngAnPhi.Text == "")
                {
                    string strMsg = "Bạn cần nhập tạm ứng án phí !";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    txtTamUngAnPhi.Focus();
                    return false;
                }
                if (txtHanNopAnPhi.Text == "")
                {
                    string strMsg = "Bạn chưa nhập hạn nộp án phí !";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    txtHanNopAnPhi.Focus();
                    return false;
                }
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
            }

            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal? DONID = Convert.ToDecimal(current_id);
            ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
            ALD_SOTHAM_THULY oTLST = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oTLST != null)
            {
                lbtthongbao.Text = "Bạn không thể lưu khi đã thụ lý sơ thẩm!";
                return false;
            }
            return true;
        }

        void SetNewSoTBAP()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_DON_BL oSTBL = new ADS_DON_BL();
            //Số Thông báo mới
            DateTime ngayTB;
            if (!String.IsNullOrEmpty(txtNgaythongbaoAP.Text))
                ngayTB = DateTime.Parse(this.txtNgaythongbaoAP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else
                ngayTB = DateTime.Now;

            String STTNew = oSTBL.GET_STB_ANPHI_NEW(DonViID, "ALD", ngayTB).ToString();
            txtSothongbaoAP.Text = STTNew;

        }

        protected void txtNgaythongbaoAP_TextChanged(object sender, EventArgs e)
        {
            SetNewSoTBAP();
        }
        protected void cmdLoad_Click(object sender, EventArgs e)
        {
            LoadGrid_XuLyDon();
            decimal DONID = Session[ENUM_LOAIAN.AN_LAODONG] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
            LoadDropDuongSu(DONID);
            LoadGrid_AnPhi();
        }

        protected void cmdLoadAP_Click(object sender, EventArgs e)
        {
            LoadGrid_AnPhi();
            LoadGrid_XuLyDon();
            decimal DONID = Session[ENUM_LOAIAN.AN_LAODONG] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
            LoadDropDuongSu(DONID);
        }
    }
}