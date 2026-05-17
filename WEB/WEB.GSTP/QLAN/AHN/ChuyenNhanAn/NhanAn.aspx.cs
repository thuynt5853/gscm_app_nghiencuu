using BL.GSTP;
using BL.GSTP.AHN;
using BL.GSTP.BANGSETGET;
using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;
using WEB.GSTP.Models;
using BL.GSTP.QLAN;

namespace WEB.GSTP.QLAN.AHN.ChuyenNhanAn
{
    public partial class NhanAn : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal DA_CHUYEN = 0, DA_NHAN = 1;
        private const string CONNECTION_TO_DB_TRUNGGIAN = "DB_TRUNG_GIAN_Connection";
        private decimal UserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                UserID = Session[ENUM_SESSION.SESSION_USERID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                if (!IsPostBack)
                {
                    // Tạm thời COMMENT Chờ kết nối
                    #region Quét các vụ việc được chuyển từ Tòa án cấp cao và lưu vào AHN_DON và AHN_CHUYEN_NHAN_AN
                    //decimal ToaAnID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
                    //// Tòa án cấp cao: TRANG_THAI=1: Đã chuyển; TRANG_THAI=2: Đã nhận
                    //string sql = "select * from HOSO where TOA_AN_XET_XU='" + ToaAnID.ToString() + "' and LOAI_AN='" + ENUM_LOAIAN.AN_HONNHAN_GIADINH + "' and TRANG_THAI=1";
                    //DataTable dlChuyenAn = Cls_Comon.GetTableToSQL(CONNECTION_TO_DB_TRUNGGIAN, sql);
                    //if (dlChuyenAn.Rows.Count > 0)
                    //{
                    //    string MaVuViec = "";
                    //    decimal MaGiaiDoan = 0, ToaXetXu = 0, Group_GiaoNhan_ID = 0, TH_Giao_Nhan_ID = 0, VuAnID = 0, Toa_Chuyen_ID = 0, Toa_Nhan_ID = 0;
                    //    bool IsNew = false;
                    //    foreach (DataRow row in dlChuyenAn.Rows)
                    //    {
                    //        IsNew = false;
                    //        MaVuViec = row["MA_HO_SO"].ToString();
                    //        MaGiaiDoan = row["CAP_XET_XU"].ToString() == "SOTHAM" ? ENUM_GIAIDOANVUAN.SOTHAM : ENUM_GIAIDOANVUAN.PHUCTHAM;
                    //        ToaXetXu = row["TOA_AN_XET_XU"] + "" == "" ? 0 : Convert.ToDecimal(row["TOA_AN_XET_XU"]);
                    //        Toa_Chuyen_ID = row["TOA_AN_CHUYEN"] + "" == "" ? 0 : Convert.ToDecimal(row["TOA_AN_CHUYEN"]);
                    //        Toa_Nhan_ID = row["TOA_AN_NHAN"] + "" == "" ? 0 : Convert.ToDecimal(row["TOA_AN_NHAN"]);
                    //        #region Update Vụ việc AHN_DON
                    //        AHN_DON vDON = dt.AHN_DON.Where(x => x.MAVUVIEC == MaVuViec && ((x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && x.TOAANID == ToaAnID) || (x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && x.TOAPHUCTHAMID == ToaAnID))).FirstOrDefault();
                    //        if (vDON == null)
                    //        {
                    //            IsNew = true;
                    //            vDON = new AHN_DON();
                    //        }
                    //        vDON.TOAANID = MaGiaiDoan == ENUM_GIAIDOANVUAN.SOTHAM ? ToaXetXu : 0;
                    //        vDON.TOAPHUCTHAMID = MaGiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM ? ToaXetXu : 0;
                    //        DM_DATAGROUP dM_DATAGROUP = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.TRUONGHOP_GIAONHAN).FirstOrDefault();
                    //        if (dM_DATAGROUP != null)
                    //        {
                    //            Group_GiaoNhan_ID = dM_DATAGROUP.ID;
                    //        }
                    //        DM_DATAITEM dM_DATAITEM = dt.DM_DATAITEM.Where(x => x.MA == ENUM_TRUONGHOP_GIAONHAN.TOA_CAPCAO_CHUYEN_VE && x.GROUPID == Group_GiaoNhan_ID).FirstOrDefault();
                    //        if (dM_DATAITEM != null)
                    //        {
                    //            TH_Giao_Nhan_ID = dM_DATAITEM.ID;
                    //        }
                    //        vDON.HINHTHUCNHANDON = TH_Giao_Nhan_ID;
                    //        vDON.MAVUVIEC = row["MA_HO_SO"] + "";
                    //        vDON.TENVUVIEC = row["TENHOSO"] + "";
                    //        vDON.MAGIAIDOAN = MaGiaiDoan;
                    //        vDON.ID_HO_SO_FROM_TOA_CAP_CAO = Encoding.ASCII.GetBytes(row["Guid"] + "");
                    //        if (IsNew)
                    //        {
                    //            dt.AHN_DON.Add(vDON);
                    //        }
                    //        dt.SaveChanges();
                    //        VuAnID = vDON.ID;
                    //        #endregion
                    //        #region Update Table AHN_CHUYEN_NHAN_AN
                    //        IsNew = false;
                    //        AHN_CHUYEN_NHAN_AN chuyen_nhan_an = dt.AHN_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID && x.TOACHUYENID == Toa_Chuyen_ID && x.TOANHANID == Toa_Nhan_ID).FirstOrDefault();
                    //        if (chuyen_nhan_an == null)
                    //        {
                    //            IsNew = true;
                    //            chuyen_nhan_an = new AHN_CHUYEN_NHAN_AN();
                    //        }
                    //        chuyen_nhan_an.VUANID = VuAnID;
                    //        chuyen_nhan_an.TOACHUYENID = Toa_Chuyen_ID;
                    //        chuyen_nhan_an.TOANHANID = Toa_Nhan_ID;
                    //        chuyen_nhan_an.TRUONGHOPGIAONHANID = TH_Giao_Nhan_ID;
                    //        DateTime NgayGiao = DateTime.MinValue, NgayNhan = DateTime.MinValue;
                    //        if (DateTime.TryParseExact(row["NGAY_CHUYEN"] + "", "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayGiao))
                    //        {
                    //            chuyen_nhan_an.NGAYGIAO = NgayGiao;
                    //        }
                    //        else
                    //        {
                    //            chuyen_nhan_an.NGAYGIAO = (DateTime?)null;
                    //        }
                    //        if (DateTime.TryParseExact(row["NGAY_NHAN"] + "", "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayNhan))
                    //        {
                    //            chuyen_nhan_an.NGAYNHAN = NgayNhan;
                    //        }
                    //        else
                    //        {
                    //            chuyen_nhan_an.NGAYNHAN = (DateTime?)null;
                    //        }
                    //        chuyen_nhan_an.NGUOIGIAOID = row["NGUOI_CHUYEN"] + "" == "" ? 0 : Convert.ToDecimal(row["NGUOI_CHUYEN"]);
                    //        chuyen_nhan_an.NGUOINHANID = row["NGUOI_NHAN"] + "" == "" ? 0 : Convert.ToDecimal(row["NGUOI_NHAN"]);
                    //        chuyen_nhan_an.TRANGTHAI = DA_CHUYEN;// Đã chuyển
                    //        chuyen_nhan_an.NGAYTAO = DateTime.Now;
                    //        if (IsNew)
                    //        {
                    //            dt.AHN_CHUYEN_NHAN_AN.Add(chuyen_nhan_an);
                    //        }
                    //        dt.SaveChanges();
                    //        #endregion
                    //    }
                    //}
                    #endregion
                    LoadTHGiaoNhan();

                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    Cls_Comon.SetButton(cmdNhanan, false);
                    Cls_Comon.SetButton(cmdHuyNhan, false);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadTHGiaoNhan()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TRUONGHOP_GIAONHAN);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ddlTHGN.DataSource = tbl;
                ddlTHGN.DataTextField = "TEN";
                ddlTHGN.DataValueField = "ID";
                ddlTHGN.DataBind();
                ddlTHGN.Items.Insert(0, new ListItem("Tất cả", "0"));
            }
        }

        private void LoadGrid()
        {
            lbthongbao.Text = "";
            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);


            TongHop_BL oBL = new TongHop_BL();
            string current_id = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.HN_NHANAN(txt_NG_KC.Text.Trim(), txtSoQD.Text.Trim(), txt_NgayQD.Text.Trim(), vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, txtTenToa.Text, Convert.ToDecimal(ddlTHGN.SelectedValue), dFrom, dTo, Convert.ToDecimal(rdbTrangthai.SelectedValue), Convert.ToDecimal(rdbLoai.SelectedValue));

            #region "Xác định số lượng trang"
            int Total = Convert.ToInt32(oDT.Rows.Count);
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            #endregion
            dgList.DataSource = oDT;
            dgList.DataBind();
        }

        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdNhanan_Click(object sender, EventArgs e)
        {
            List<CUS_NHANAN_INPUT> data = new List<CUS_NHANAN_INPUT>();

            lbthongbao.Text = "";
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    //hddChuyenNhanAnID.Value = Item.Cells[0].Text;
                    //txtN_Mavuviec.Text = Item.Cells[1].Text;
                    //txtN_Tenvuviec.Text = Item.Cells[4].Text;
                    //txtN_Ngaygiao.Text = Item.Cells[7].Text;
                    //txtN_Toagiao.Text = Item.Cells[5].Text;
                    //txtToanhan.Text = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    //txtN_THGN.Text = Item.Cells[9].Text;
                    //txtNgayNhan.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    // DropDownList ddlN_Nguoinhan = (DropDownList)item.FindControl("ddlN_Nguoinhan");

                    CUS_NHANAN_INPUT input = new CUS_NHANAN_INPUT();
                    input.NhanAnID = Item.Cells[0].Text;
                    input.MaVuViec = Item.Cells[1].Text;
                    input.TenVuViec = Item.Cells[4].Text;
                    input.NgayGiao = Item.Cells[7].Text;
                    input.ToaGiao = Item.Cells[5].Text;
                    input.ToaNhan = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    input.TruongHopGiaoNhan = Item.Cells[9].Text;
                    input.NgayNhan = DateTime.Now.ToString("dd/MM/yyyy");
                    data.Add(input);
                }
            }


            rptCapNhat.DataSource = data;
            rptCapNhat.DataBind();

            pnDanhsach.Visible = false;
            pnCapnhat.Visible = true;
        }
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            Cls_Comon.SetButton(cmdNhanan, false);
            Cls_Comon.SetButton(cmdNhandon, false);
            Cls_Comon.SetButton(cmdHuyNhan, false);
            Cls_Comon.SetButton(cmdHuyNhandon, false);
            if (rdbTrangthai.SelectedValue == "1")
            {
                Cls_Comon.SetButton(cmdNhanan, false);
                Cls_Comon.SetButton(cmdNhandon, false);
                Cls_Comon.SetButton(cmdHuyNhan, true);
                Cls_Comon.SetButton(cmdHuyNhandon, true);
            }
            else
            {
                Cls_Comon.SetButton(cmdNhanan, true);
                Cls_Comon.SetButton(cmdNhandon, true);
                Cls_Comon.SetButton(cmdHuyNhan, false);
                Cls_Comon.SetButton(cmdHuyNhandon, false);
            }
            //CheckBox chkXem = (CheckBox)sender;
            //foreach (DataGridItem Item in dgList.Items)
            //{
            //    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
            //    if (chkXem.Checked)
            //    {
            //        if (chkXem.ToolTip != chkChon.ToolTip) chkChon.Checked = false;
            //    }
            //}
        }
        private void UpdateDuongSuIdTGTT(AHN_DON_THAMGIATOTUNG oTTOLD, AHN_DON_THAMGIATOTUNG oTTNEW, List<DuongSuTemp> lstDuongSuTemp)
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

        public class DonChiTietIdModel
        {
            public decimal OldId { get; set; }
            public decimal NewId { get; set; }
        }

        protected void cmdLuu_Click(object sender, EventArgs e)
        {


            foreach (RepeaterItem item in rptCapNhat.Items)
            {

                TextBox txtNgayNhan = (TextBox)item.FindControl("txtNgayNhan");
                if (Cls_Comon.IsValidDate(txtNgayNhan.Text) == false)
                {
                    lbthongbaoNA.Text = "Bạn phải nhập ngày nhận theo định dạng (dd/MM/yyyy).";
                    txtNgayNhan.Focus();
                    return;
                }

                TextBox txtN_Ngaygiao = (TextBox)item.FindControl("txtN_Ngaygiao");
                if (!string.IsNullOrEmpty(txtN_Ngaygiao.Text))
                {
                    if (Cls_Comon.IsValidDate(txtN_Ngaygiao.Text) == false)
                    {
                        lbthongbaoNA.Text = "Bạn phải nhập ngày giao theo định dạng (dd/MM/yyyy).";
                        txtN_Ngaygiao.Focus();
                        return;
                    }


                    var dtNgayNhan = Cls_Comon.toDate(txtNgayNhan.Text);
                    var dtN_Ngaygiao = Cls_Comon.toDate(txtN_Ngaygiao.Text);

                    if (dtNgayNhan < dtN_Ngaygiao)
                    {
                        lbthongbaoNA.Text = "Ngày nhận vụ án bắt buộc phải lớn hơn hoặc bằng ngày giao ";
                        txtN_Ngaygiao.Focus();
                        return;
                    }
                }

            }

            foreach (RepeaterItem item in rptCapNhat.Items)
            {


                HiddenField hddChuyenNhanAnID = (HiddenField)item.FindControl("hddChuyenNhanAnID");

                TextBox txtN_Mavuviec = (TextBox)item.FindControl("txtN_Mavuviec");
                TextBox txtN_Tenvuviec = (TextBox)item.FindControl("txtN_Tenvuviec");
                TextBox txtN_Ngaygiao = (TextBox)item.FindControl("txtN_Ngaygiao");
                TextBox txtN_Toagiao = (TextBox)item.FindControl("txtN_Toagiao");
                TextBox txtToanhan = (TextBox)item.FindControl("txtToanhan");
                TextBox txtN_THGN = (TextBox)item.FindControl("txtN_THGN");
                TextBox txtNgayNhan = (TextBox)item.FindControl("txtNgayNhan");
                DropDownList ddlN_Nguoinhan = (DropDownList)item.FindControl("ddlN_Nguoinhan");



                decimal ID = Convert.ToDecimal(hddChuyenNhanAnID.Value);
                AHN_CHUYEN_NHAN_AN oT = dt.AHN_CHUYEN_NHAN_AN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    decimal DonID = (decimal)oT.VUANID;
                    //Cập nhật lại thông tin án
                    AHN_DON oDon = dt.AHN_DON.Where(x => x.ID == DonID).FirstOrDefault();
                    DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.ID == oT.TRUONGHOPGIAONHANID).FirstOrDefault();
                    if (oIT.MA == ENUM_TRUONGHOP_GIAONHAN.KHONGTHUOC_THAMQUYEN_XETXU)
                    {
                        if (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM)
                        {
                            oDon.TOAPHUCTHAMID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        }
                        else
                        {
                            if (rdbLoai.SelectedValue == "0")
                            {
                                #region tạo đơn toà án mới
                                AHN_DON oDonMoi = new AHN_DON();

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
                                //oDonMoi.TOAPHUCTHAMID = oDon.TOAPHUCTHAMID;
                                oDonMoi.QHPLTKID = oDon.QHPLTKID;
                                //oDonMoi.THONGTINTHEM = oDon.THONGTINTHEM;
                                oDonMoi.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                                oDonMoi.QUANHEPHAPLUAT_NAME = oDon.QUANHEPHAPLUAT_NAME;
                                //oDonMoi.TENVUVIEC_PT = oDon.TENVUVIEC_PT;
                                //mã vụ việc sinh ra thao tòa án mới
                                AHN_DON_BL dsBL = new AHN_DON_BL();
                                oDonMoi.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oDonMoi.TOAANID.Value).FirstOrDefault();
                                oDonMoi.TT = dsBL.GETNEWTT((decimal)oDonMoi.TOAANID);
                                oDonMoi.MAVUVIEC = ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH + oTA.MA + oDonMoi.TT.ToString();
                                oDonMoi.CANBONHANDONID = 0;
                                oDonMoi.THAMPHANKYNHANDON = 0;
                                oDonMoi.LOAIDON = 1;
                                oDonMoi.TRANGTHAI = 0;
                                //lưu id đơn cũ khi chuyển đơn sang tòa án khác
                                oDonMoi.DONID_TOACU = oDon.DONID_TOACU.HasValue ? oDon.DONID_TOACU.Value : oDon.ID;
                                oDonMoi.TOA_GIAIQUYET_ID = oDon.TOA_GIAIQUYET_ID;

                                dt.AHN_DON.Add(oDonMoi);
                                dt.SaveChanges();

                                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                                GD.GAIDOAN_INSERT_UPDATE("3", oDonMoi.ID, 2, oDonMoi.TOAANID.Value, 0, 0, 0, 0);
                                List<DuongSuTemp> lstDuongSuTemp = new List<DuongSuTemp>();

                                IQueryable<DON_CHITIET> lstDON_CHITIET = dt.DON_CHITIET.Where(s => s.DONID == oDon.ID);
                                var listDOnCT = new List<KeyValuePair<decimal, decimal>>();
                                foreach (var it in lstDON_CHITIET)
                                {
                                    DON_CHITIET oKC = new DON_CHITIET();

                                    oKC.DONID = oDonMoi.ID;
                                    oKC.LOAIANID = it.LOAIANID;
                                    oKC.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                    oKC.HINHTHUCNHANDON = it.HINHTHUCNHANDON;
                                    oKC.NGAYVIETDON = it.NGAYVIETDON;
                                    oKC.NGAYNHANDON = it.NGAYNHANDON;
                                    oKC.CANBONHANDONID = it.CANBONHANDONID;
                                    oKC.THAMPHANKYNHANDON = it.THAMPHANKYNHANDON;
                                    oKC.YEUTONUOCNGOAI = it.YEUTONUOCNGOAI;
                                    oKC.LOAIDON = it.LOAIDON;
                                    oKC.USERTT_EMAIL = it.USERTT_EMAIL;
                                    oKC.USERTT_ID = it.USERTT_ID;
                                    oKC.USERTT_NGAYTAO = it.USERTT_NGAYTAO;
                                    oKC.USERTT_NGAYGUI = it.USERTT_NGAYGUI;
                                    oKC.USERTT_NGAYBOSUNG = it.USERTT_NGAYBOSUNG;
                                    oKC.NGUOITAO = it.NGUOITAO;
                                    oKC.NGAYTAO = it.NGAYTAO;
                                    oKC.NGUOISUA = it.NGUOISUA;
                                    oKC.NGAYSUA = it.NGAYSUA;
                                    oKC.NOIDUNGKHOIKIEN = it.NOIDUNGKHOIKIEN;
                                    oKC.THONGTINTHEM = it.THONGTINTHEM;
                                    oKC.DONKKID = it.DONKKID;
                                    oKC.GHICHU = it.GHICHU;
                                    oKC.TTGQ = it.TTGQ;
                                    oKC.NOIDUNGTTGQ = it.NOIDUNGTTGQ;
                                    oKC.DONGUINHANID = it.DONGUINHANID;
                                    oKC.IS_NHAPAN = it.IS_NHAPAN;
                                    oKC.TOA_GIAIQUYET_ID = it.TOA_GIAIQUYET_ID;
                                    dt.DON_CHITIET.Add(oKC);
                                    dt.SaveChanges();
                                    
                                    listDOnCT.Add(new KeyValuePair<decimal, decimal>(it.ID, oKC.ID));
                                }
                                //lấy danh sách đương sự
                                IQueryable<AHN_DON_DUONGSU> lstoDS = dt.AHN_DON_DUONGSU.Where(s => s.DONID == oDon.ID);
                                foreach (var it in lstoDS)
                                {
                                    AHN_DON_DUONGSU oDS = new AHN_DON_DUONGSU();
                                    oDS.DONID = oDonMoi.ID;
                                    oDS.MADUONGSU = it.MADUONGSU;
                                    oDS.TENDUONGSU = it.TENDUONGSU;
                                    oDS.ISDAIDIEN = it.ISDAIDIEN;
                                    oDS.TUCACHTOTUNG_MA = it.TUCACHTOTUNG_MA;
                                    oDS.LOAIDUONGSU = it.LOAIDUONGSU;
                                    oDS.SOCMND = it.SOCMND;
                                    oDS.QUOCTICHID = it.QUOCTICHID;
                                    oDS.TAMTRUID = it.TAMTRUID;
                                    oDS.TAMTRUCHITIET = it.TAMTRUCHITIET;
                                    oDS.HKTTID = it.HKTTID;
                                    oDS.HKTTCHITIET = it.HKTTCHITIET;
                                    oDS.NGAYSINH = it.NGAYSINH;
                                    oDS.THANGSINH = it.THANGSINH;
                                    oDS.NAMSINH = it.NAMSINH;
                                    oDS.GIOITINH = it.GIOITINH;
                                    oDS.NGUOIDAIDIEN = it.NGUOIDAIDIEN;
                                    oDS.CHUCVU = it.CHUCVU;
                                    oDS.NGUOITAO = it.NGUOITAO;
                                    oDS.NGAYTAO = it.NGAYTAO;
                                    oDS.NGUOISUA = it.NGUOISUA;
                                    oDS.NGAYSUA = it.NGAYSUA;
                                    oDS.NDD_DIACHIID = it.NDD_DIACHIID;
                                    oDS.NDD_DIACHICHITIET = it.NDD_DIACHICHITIET;
                                    oDS.ISSOTHAM = it.ISSOTHAM;
                                    oDS.ISPHUCTHAM = it.ISPHUCTHAM;
                                    oDS.ISGDT = it.ISGDT;
                                    oDS.ISDON = it.ISDON;
                                    oDS.EMAIL = it.EMAIL;
                                    oDS.DIENTHOAI = it.DIENTHOAI;
                                    oDS.FAX = it.FAX;
                                    oDS.SINHSONG_NUOCNGOAI = it.SINHSONG_NUOCNGOAI;
                                    oDS.HKTTTINHID = it.HKTTTINHID;
                                    oDS.TAMTRUTINHID = it.TAMTRUTINHID;
                                    oDS.ISBVQLNGUOIKHAC = it.ISBVQLNGUOIKHAC;
                                    oDS.TUOI = it.TUOI;
                                    oDS.DIACHICOQUAN = it.DIACHICOQUAN;
                                    oDS.ID_DUONGSU_TACC = it.ID_DUONGSU_TACC;
                                    oDS.ISDONCHITIET = it.ISDONCHITIET;
                                    oDS.ISDAIDIEN_DONCHITIET = it.ISDAIDIEN_DONCHITIET;
                                    oDS.TOA_GIAIQUYET_ID = it.TOA_GIAIQUYET_ID;
                                    dt.AHN_DON_DUONGSU.Add(oDS);
                                    dt.SaveChanges();

                                    lstDuongSuTemp.Add(new DuongSuTemp(it.ID, oDS.ID));

                                    IQueryable<DON_DUONGSU_CHITIET> lstDON_DUONGSU_CHITIET = dt.DON_DUONGSU_CHITIET.Where(s => s.DONID == oDon.ID && s.DUONGSUID == it.ID);
                                    foreach (var itDSCT in lstDON_DUONGSU_CHITIET)
                                    {
                                        DON_DUONGSU_CHITIET oKC = new DON_DUONGSU_CHITIET();
                                        oKC.DONID = oDonMoi.ID;
                                        oKC.DUONGSUID = oDS.ID;
                                        oKC.LOAIAN = itDSCT.LOAIAN;
                                        foreach (var itemDonCTId in listDOnCT)
                                        {
                                            if (itemDonCTId.Key == itDSCT.DONCHITIETID)
                                            {
                                                oKC.DONCHITIETID = itemDonCTId.Value;
                                            }
                                        }
                                        oKC.NGUOITAO = itDSCT.NGUOITAO;
                                        oKC.NGAYTAO = itDSCT.NGAYTAO;
                                        oKC.NGUOISUA = itDSCT.NGUOISUA;
                                        oKC.NGAYSUA = itDSCT.NGAYSUA;
                                        oKC.TOA_GIAIQUYET_ID = itDSCT.TOA_GIAIQUYET_ID;
                                        dt.DON_DUONGSU_CHITIET.Add(oKC);
                                        dt.SaveChanges();
                                    }
                                }


                                //lấy danh sách người tham gia tố tụng
                                IQueryable<AHN_DON_THAMGIATOTUNG> lstoTT = dt.AHN_DON_THAMGIATOTUNG.Where(s => s.DONID == oDon.ID);
                                foreach (var it in lstoTT)
                                {
                                    //lưu thông tin người tham gia tố tụng
                                    AHN_DON_THAMGIATOTUNG oTT = new AHN_DON_THAMGIATOTUNG();
                                    oTT.DONID = oDonMoi.ID;
                                    oTT.HOTEN = it.HOTEN;
                                    oTT.TAMTRUID = it.TAMTRUID;
                                    oTT.TAMTRUCHITIET = it.TAMTRUCHITIET;
                                    oTT.HKTTID = it.HKTTID;
                                    oTT.HKTTCHITIET = it.HKTTCHITIET;
                                    oTT.NGAYSINH = it.NGAYSINH;
                                    oTT.THANGSINH = it.THANGSINH;
                                    oTT.NAMSINH = it.NAMSINH;
                                    oTT.GIOITINH = it.GIOITINH;
                                    oTT.TUCACHTGTTID = it.TUCACHTGTTID;
                                    oTT.NGUOIDAIDIEN = it.NGUOIDAIDIEN;
                                    oTT.CHUCVU = it.CHUCVU;
                                    oTT.NGAYTHAMGIA = it.NGAYTHAMGIA;
                                    oTT.NGAYKETTHUC = it.NGAYKETTHUC;
                                    oTT.NGAYTAO = it.NGAYTAO;
                                    oTT.NGUOITAO = it.NGUOITAO;
                                    oTT.NGAYSUA = it.NGAYSUA;
                                    oTT.NGUOISUA = it.NGUOISUA;
                                    oTT.EMAIL = it.EMAIL;
                                    oTT.DIENTHOAI = it.DIENTHOAI;
                                    oTT.FAX = it.FAX;
                                    oTT.HKTTTINHID = it.HKTTTINHID;
                                    oTT.TAMTRUTINHID = it.TAMTRUTINHID;
                                    oTT.ID_DUONGSU_TACC = it.ID_DUONGSU_TACC;
                                    UpdateDuongSuIdTGTT(it, oTT, lstDuongSuTemp);
                                    //oTT.DUONGSUID = it.DUONGSUID;
                                    oTT.TOA_GIAIQUYET_ID = it.TOA_GIAIQUYET_ID;

                                    dt.AHN_DON_THAMGIATOTUNG.Add(oTT);
                                    dt.SaveChanges();
                                }


                                IQueryable<AHN_DON_TAILIEU> lstTailieu = dt.AHN_DON_TAILIEU.Where(s => s.DONID == oDon.ID);
                                foreach (var it in lstTailieu)
                                {
                                    AHN_DON_TAILIEU objtl = new AHN_DON_TAILIEU();
                                    objtl.DONID = oDonMoi.ID;
                                    objtl.TENTAILIEU = it.TENTAILIEU;
                                    objtl.TENFILE = it.TENFILE;
                                    objtl.LOAIFILE = it.LOAIFILE;
                                    objtl.NOIDUNG = it.NOIDUNG;
                                    objtl.NGUOITAO = it.NGUOITAO;
                                    objtl.NGAYTAO = it.NGAYTAO;
                                    objtl.NGUOISUA = it.NGUOISUA;
                                    objtl.NGAYSUA = it.NGAYSUA;
                                    objtl.BANGIAOID = it.BANGIAOID;
                                    objtl.NGAYBANGIAO = it.NGAYBANGIAO;
                                    objtl.NGUOIBANGIAO = it.NGUOIBANGIAO;
                                    objtl.LOAIDOITUONG = it.LOAIDOITUONG;
                                    objtl.NGUOINHANID = it.NGUOINHANID;
                                    objtl.TOA_GIAIQUYET_ID = it.TOA_GIAIQUYET_ID;
                                    dt.AHN_DON_TAILIEU.Add(objtl);
                                    dt.SaveChanges();
                                }

                                

                                


                                oT.MAP_VUANID_NEW = oDonMoi.ID;

                                #endregion tạo đơn toà án mới
                            }

                            else
                        {
                            //    oDon.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            /*  Lê Nam
                                Chuyển án không thuộc thẩm quyền
                            */
                            string UserName = Session[ENUM_SESSION.SESSION_USERNAME] + "", LoaiVuViec = ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH, MaToaAn = Session[ENUM_SESSION.SESSION_MADONVI] + "";
                            decimal ToaAnNhan = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
                                    DonID_New = Action_ChuyenAn_KhongThuoc_ThamQuyen(DonID, LoaiVuViec, ToaAnNhan, MaToaAn, UserName);
                            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            GD.GAIDOAN_INSERT_UPDATE("3", DonID_New, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                        }
                    }
                    }
                    else if (oIT.MA == ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM)
                    {
                        if (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                        {
                            AHN_CHUYEN_NHAN_AN_BL _caBL = new AHN_CHUYEN_NHAN_AN_BL();
                            decimal donIdOld = _caBL.getDonIdOld(oDon.ID);
                            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            AHN_DON oDonOld = dt.AHN_DON.Where(x => x.ID == donIdOld).FirstOrDefault();
                            oDonOld.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            dt.SaveChanges();
                            GD.GAIDOAN_INSERT_UPDATE("2", donIdOld, ENUM_GIAIDOANVUAN.SOTHAM, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                            #region toancau - anhnt update lại kết quả kháng cáo/kháng nghị
                            List<AHN_SOTHAM_KHANGCAO> khangCaos = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == donIdOld && (x.TINHTRANG_GIAIQUYET == null || x.TINHTRANG_GIAIQUYET == 0) && x.LOAIKHANGCAO == 2).ToList();
                            if (khangCaos != null && khangCaos.Count > 0)
                            {
                                foreach (AHN_SOTHAM_KHANGCAO kc in khangCaos)
                                {
                                    kc.TINHTRANG_GIAIQUYET = 1;
                                    dt.SaveChanges();
                                }
                            }
                            List<AHN_SOTHAM_KHANGNGHI> khangNghis = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.DONID == donIdOld && (x.TINHTRANG_GIAIQUYET == null || x.TINHTRANG_GIAIQUYET == 0) && x.LOAIKN == 2).ToList();
                            if (khangNghis != null && khangNghis.Count > 0)
                            {
                                foreach (AHN_SOTHAM_KHANGNGHI kn in khangNghis)
                                {
                                    kn.TINHTRANG_GIAIQUYET = 1;
                                    dt.SaveChanges();
                                }
                            }
                            #endregion toancau - anhnt update lại kết quả kháng cáo/kháng nghị
                        }
                        else
                        {
                            //oDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            //dt.SaveChanges();
                            ////anhvh add 26/06/2020
                            //GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            //GD.GAIDOAN_INSERT_UPDATE("3", DonID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                            AHN_DON oDON_new = new AHN_DON();
                            oDON_new.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            oDON_new.MAVUVIEC = oDon.MAVUVIEC;
                            oDON_new.TENVUVIEC = oDon.TENVUVIEC;
                            oDON_new.SOTHUTU = oDon.SOTHUTU;
                            // VNPT HOANGNDH 10/12/2025
                            // update TH giao nhận về xét xử lại sơ thẩm
                            oDON_new.HINHTHUCNHANDON = oIT.ID;
                            oDON_new.NGAYVIETDON = oDon.NGAYVIETDON;
                            oDON_new.NGAYNHANDON = oDon.NGAYNHANDON;
                            oDON_new.LOAIQUANHE = oDon.LOAIQUANHE;
                            oDON_new.QUANHEPHAPLUATID = oDon.QUANHEPHAPLUATID;
                            oDON_new.CANBONHANDONID = oDon.CANBONHANDONID;
                            oDON_new.THAMPHANKYNHANDON = oDon.THAMPHANKYNHANDON;
                            oDON_new.YEUTONUOCNGOAI = oDon.YEUTONUOCNGOAI;
                            oDON_new.DONKIENCUANGUOIKHAC = oDon.DONKIENCUANGUOIKHAC;
                            oDON_new.LOAIDON = oDon.LOAIDON;
                            oDON_new.TRANGTHAI = oDon.TRANGTHAI;
                            oDON_new.USERTT_EMAIL = oDon.USERTT_EMAIL;
                            oDON_new.USERTT_ID = oDon.USERTT_ID;
                            oDON_new.USERTT_NGAYTAO = oDon.USERTT_NGAYTAO;
                            oDON_new.USERTT_NGAYGUI = oDon.USERTT_NGAYGUI;
                            oDON_new.USERTT_NGAYBOSUNG = oDon.USERTT_NGAYBOSUNG;

                            oDON_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            oDON_new.NGAYTAO = DateTime.Now;
                            AHN_DON_BL dsBL = new AHN_DON_BL();
                            oDON_new.TT = dsBL.GETNEWTT((decimal)oDON_new.TOAANID);

                            oDON_new.LYDOLYHONID = oDon.LYDOLYHONID;
                            oDON_new.SOCONCHUATHANHNIEN = oDon.SOCONCHUATHANHNIEN;
                            oDON_new.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            oDON_new.NOIDUNGKHOIKIEN = oDon.NOIDUNGKHOIKIEN;
                            oDON_new.MABAOMAT = oDon.MABAOMAT;
                            oDON_new.TOAPHUCTHAMID = oDon.TOAPHUCTHAMID;
                            oDON_new.QHPLTKID = oDon.QHPLTKID;
                            oDON_new.SOCONDUOI7TUOI = oDon.SOCONDUOI7TUOI;
                            oDON_new.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                            oDON_new.QUANHEPHAPLUAT_NAME = oDon.QUANHEPHAPLUAT_NAME;
                            //oDON_new.TENVUVIEC_PT = oDon.TENVUVIEC_PT;
                            oDON_new.DONID_TOACU = oDon.DONID_TOACU;
                            oDON_new.TOA_GIAIQUYET_ID = oDon.TOA_GIAIQUYET_ID;

                            dt.AHN_DON.Add(oDON_new);
                            dt.SaveChanges();

                            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            GD.GAIDOAN_INSERT_UPDATE("3", oDON_new.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);

                            IQueryable<DON_CHITIET> lstDON_CHITIET = dt.DON_CHITIET.Where(s => s.DONID == oDon.ID);
                            var listDOnCT = new List<KeyValuePair<decimal, decimal>>();
                            foreach (var it in lstDON_CHITIET)
                            {
                                DON_CHITIET oKC = new DON_CHITIET();

                                oKC.DONID = oDON_new.ID;
                                oKC.LOAIANID = it.LOAIANID;
                                oKC.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                oKC.HINHTHUCNHANDON = it.HINHTHUCNHANDON;
                                oKC.NGAYVIETDON = it.NGAYVIETDON;
                                oKC.NGAYNHANDON = it.NGAYNHANDON;
                                oKC.CANBONHANDONID = it.CANBONHANDONID;
                                oKC.THAMPHANKYNHANDON = it.THAMPHANKYNHANDON;
                                oKC.YEUTONUOCNGOAI = it.YEUTONUOCNGOAI;
                                oKC.LOAIDON = it.LOAIDON;
                                oKC.USERTT_EMAIL = it.USERTT_EMAIL;
                                oKC.USERTT_ID = it.USERTT_ID;
                                oKC.USERTT_NGAYTAO = it.USERTT_NGAYTAO;
                                oKC.USERTT_NGAYGUI = it.USERTT_NGAYGUI;
                                oKC.USERTT_NGAYBOSUNG = it.USERTT_NGAYBOSUNG;
                                oKC.NGUOITAO = it.NGUOITAO;
                                oKC.NGAYTAO = it.NGAYTAO;
                                oKC.NGUOISUA = it.NGUOISUA;
                                oKC.NGAYSUA = it.NGAYSUA;
                                oKC.NOIDUNGKHOIKIEN = it.NOIDUNGKHOIKIEN;
                                oKC.THONGTINTHEM = it.THONGTINTHEM;
                                oKC.DONKKID = it.DONKKID;
                                oKC.GHICHU = it.GHICHU;
                                oKC.TTGQ = it.TTGQ;
                                oKC.NOIDUNGTTGQ = it.NOIDUNGTTGQ;
                                oKC.DONGUINHANID = it.DONGUINHANID;
                                oKC.IS_NHAPAN = it.IS_NHAPAN;
                                oKC.TOA_GIAIQUYET_ID = it.TOA_GIAIQUYET_ID;
                                dt.DON_CHITIET.Add(oKC);
                                dt.SaveChanges();
                                
                                listDOnCT.Add(new KeyValuePair<decimal, decimal>(it.ID, oKC.ID));
                            }
                            //Câp dương su vụ án
                            List<AHN_DON_DUONGSU> lst = dt.AHN_DON_DUONGSU.Where(x => x.DONID == DonID).ToList<AHN_DON_DUONGSU>();
                            foreach (AHN_DON_DUONGSU vDuongsu_old in lst)
                            {
                                AHN_DON_DUONGSU vDuongsu_new = new AHN_DON_DUONGSU();

                                vDuongsu_new.DONID = oDON_new.ID;
                                vDuongsu_new.MADUONGSU = vDuongsu_old.MADUONGSU;
                                vDuongsu_new.TENDUONGSU = vDuongsu_old.TENDUONGSU;
                                vDuongsu_new.ISDAIDIEN = vDuongsu_old.ISDAIDIEN;
                                vDuongsu_new.TUCACHTOTUNG_MA = vDuongsu_old.TUCACHTOTUNG_MA;
                                vDuongsu_new.LOAIDUONGSU = vDuongsu_old.LOAIDUONGSU;
                                vDuongsu_new.SOCMND = vDuongsu_old.SOCMND;
                                vDuongsu_new.QUOCTICHID = vDuongsu_old.QUOCTICHID;
                                vDuongsu_new.TAMTRUID = vDuongsu_old.TAMTRUID;
                                vDuongsu_new.TAMTRUCHITIET = vDuongsu_old.TAMTRUCHITIET;
                                vDuongsu_new.HKTTID = vDuongsu_old.HKTTID;
                                vDuongsu_new.HKTTCHITIET = vDuongsu_old.HKTTCHITIET;
                                vDuongsu_new.NGAYSINH = vDuongsu_old.NGAYSINH;
                                vDuongsu_new.THANGSINH = vDuongsu_old.THANGSINH;
                                vDuongsu_new.NAMSINH = vDuongsu_old.NAMSINH;
                                vDuongsu_new.GIOITINH = vDuongsu_old.GIOITINH;
                                vDuongsu_new.NGUOIDAIDIEN = vDuongsu_old.NGUOIDAIDIEN;
                                vDuongsu_new.CHUCVU = vDuongsu_old.CHUCVU;
                                vDuongsu_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                vDuongsu_new.NGAYTAO = DateTime.Now;
                                vDuongsu_new.NDD_DIACHIID = vDuongsu_old.NDD_DIACHIID;
                                vDuongsu_new.NDD_DIACHICHITIET = vDuongsu_old.NDD_DIACHICHITIET;
                                vDuongsu_new.ISSOTHAM = vDuongsu_old.ISSOTHAM;
                                vDuongsu_new.ISPHUCTHAM = vDuongsu_old.ISPHUCTHAM;
                                vDuongsu_new.ISGDT = vDuongsu_old.ISGDT;
                                vDuongsu_new.ISDON = vDuongsu_old.ISDON;
                                vDuongsu_new.EMAIL = vDuongsu_old.EMAIL;
                                vDuongsu_new.DIENTHOAI = vDuongsu_old.DIENTHOAI;
                                vDuongsu_new.FAX = vDuongsu_old.FAX;
                                vDuongsu_new.SINHSONG_NUOCNGOAI = vDuongsu_old.SINHSONG_NUOCNGOAI;
                                vDuongsu_new.HKTTTINHID = vDuongsu_old.HKTTTINHID;
                                vDuongsu_new.TAMTRUTINHID = vDuongsu_old.TAMTRUTINHID;
                                vDuongsu_new.DIACHICOQUAN = vDuongsu_old.DIACHICOQUAN;
                                vDuongsu_new.ID_DUONGSU_TACC = vDuongsu_old.ID_DUONGSU_TACC;
                                vDuongsu_new.ISDONCHITIET = vDuongsu_old.ISDONCHITIET;
                                vDuongsu_new.ISDAIDIEN_DONCHITIET = vDuongsu_old.ISDAIDIEN_DONCHITIET;
                                vDuongsu_new.TOA_GIAIQUYET_ID = vDuongsu_old.TOA_GIAIQUYET_ID;
                                // vnpt 06/12/2025
                                vDuongsu_new.XACTHUC_DLDCQG = vDuongsu_old.XACTHUC_DLDCQG;
                                dt.AHN_DON_DUONGSU.Add(vDuongsu_new);
                                dt.SaveChanges();
                                //Ban giao tai lieu
                                List<AHN_DON_TAILIEU> lstTaiLieu = dt.AHN_DON_TAILIEU.Where(x => x.DONID == DonID && x.NGUOIBANGIAO == vDuongsu_old.ID).ToList<AHN_DON_TAILIEU>();
                                foreach (AHN_DON_TAILIEU vdonFile_old in lstTaiLieu)
                                {
                                    AHN_DON_TAILIEU donFile_new = new AHN_DON_TAILIEU();
                                    donFile_new.DONID = oDON_new.ID;
                                    donFile_new.TENTAILIEU = vdonFile_old.TENTAILIEU;
                                    donFile_new.TENFILE = vdonFile_old.TENFILE;
                                    donFile_new.LOAIFILE = vdonFile_old.LOAIFILE;
                                    donFile_new.NOIDUNG = vdonFile_old.NOIDUNG;
                                    donFile_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    donFile_new.NGAYTAO = DateTime.Now;
                                    donFile_new.BANGIAOID = vdonFile_old.BANGIAOID;
                                    donFile_new.NGAYBANGIAO = vdonFile_old.NGAYBANGIAO;
                                    donFile_new.NGUOIBANGIAO = vDuongsu_new.ID; //Luu duong su moi
                                    donFile_new.LOAIDOITUONG = vdonFile_old.LOAIDOITUONG;
                                    donFile_new.NGUOINHANID = vdonFile_old.NGUOINHANID;
                                    donFile_new.TOA_GIAIQUYET_ID = vdonFile_old.TOA_GIAIQUYET_ID;
                                    dt.AHN_DON_TAILIEU.Add(donFile_new);
                                    dt.SaveChanges();
                                }

                                IQueryable<DON_DUONGSU_CHITIET> lstDON_DUONGSU_CHITIET = dt.DON_DUONGSU_CHITIET.Where(s => s.DONID == oDon.ID && s.DUONGSUID == vDuongsu_old.ID);
                                foreach (var ddsct_data in lstDON_DUONGSU_CHITIET)
                                {
                                    DON_DUONGSU_CHITIET ddsct = new DON_DUONGSU_CHITIET();
                                    ddsct.DONID = oDON_new.ID;
                                    ddsct.DUONGSUID = vDuongsu_new.ID;
                                    ddsct.LOAIAN = ddsct_data.LOAIAN;
                                    foreach (var itemDonCTId in listDOnCT)
                                    {
                                        if (itemDonCTId.Key == ddsct_data.DONCHITIETID)
                                        {
                                            ddsct.DONCHITIETID = itemDonCTId.Value;
                                        }
                                    }
                                    ddsct.NGUOITAO = ddsct_data.NGUOITAO;
                                    ddsct.NGAYTAO = ddsct_data.NGAYTAO;
                                    ddsct.NGUOISUA = ddsct_data.NGUOISUA;
                                    ddsct.NGAYSUA = ddsct_data.NGAYSUA;
                                    ddsct.TOA_GIAIQUYET_ID = ddsct_data.TOA_GIAIQUYET_ID;
                                    dt.DON_DUONGSU_CHITIET.Add(ddsct);
                                    dt.SaveChanges();
                                }

                            }
                            // Phan cong Tham phan
                            List<AHN_DON_THAMPHAN> lstThamPhan = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).ToList<AHN_DON_THAMPHAN>();
                            foreach (AHN_DON_THAMPHAN vThamphan_old in lstThamPhan)
                            {
                                AHN_DON_THAMPHAN vThamphan_new = new AHN_DON_THAMPHAN();
                                vThamphan_new.DONID = oDON_new.ID;
                                vThamphan_new.CANBOID = vThamphan_old.CANBOID;
                                vThamphan_new.MAVAITRO = vThamphan_old.MAVAITRO;
                                vThamphan_new.NGAYPHANCONG = vThamphan_old.NGAYPHANCONG;
                                vThamphan_new.NGAYNHANPHANCONG = vThamphan_old.NGAYNHANPHANCONG;
                                vThamphan_new.NGAYTHAMGIA = vThamphan_old.NGAYTHAMGIA;
                                vThamphan_new.NGAYKETTHUC = vThamphan_old.NGAYKETTHUC;
                                vThamphan_new.NGUOIPHANCONGID = vThamphan_old.NGUOIPHANCONGID;
                                vThamphan_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                vThamphan_new.NGAYTAO = DateTime.Now;
                                vThamphan_new.ID_PHAN_CONG_AN = vThamphan_old.ID_PHAN_CONG_AN;
                                vThamphan_new.THUKYID = vThamphan_old.THUKYID;
                                vThamphan_new.TOA_GIAIQUYET_ID = vThamphan_old.TOA_GIAIQUYET_ID;
                                dt.AHN_DON_THAMPHAN.Add(vThamphan_new);
                                dt.SaveChanges();
                            }
                            //Xu ly don
                            List<AHN_DON_XULY> lstXulyDon = dt.AHN_DON_XULY.Where(x => x.DONID == DonID).ToList<AHN_DON_XULY>();
                            foreach (AHN_DON_XULY vXulyDon_old in lstXulyDon)
                            {
                                AHN_DON_XULY vXulyDon_new = new AHN_DON_XULY();
                                vXulyDon_new.DONID = oDON_new.ID;
                                vXulyDon_new.LOAIGIAIQUYET = vXulyDon_old.LOAIGIAIQUYET;
                                vXulyDon_new.NGAYGQ_YC = vXulyDon_old.NGAYGQ_YC;
                                vXulyDon_new.LYDO = vXulyDon_old.LYDO;
                                vXulyDon_new.CDTN_TOAANID = vXulyDon_old.CDTN_TOAANID;
                                vXulyDon_new.CDTN_NGAYNHAN = vXulyDon_old.CDTN_NGAYNHAN;
                                vXulyDon_new.CDNN_TENCQ = vXulyDon_old.CDNN_TENCQ;
                                vXulyDon_new.TRADON_CANCUID = vXulyDon_old.TRADON_CANCUID;
                                vXulyDon_new.NGAYTAO = DateTime.Now;
                                vXulyDon_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                vXulyDon_new.CDNN_NGAYCHUYEN = vXulyDon_old.CDNN_NGAYCHUYEN;
                                vXulyDon_new.TRADON_LYDOID = vXulyDon_old.TRADON_LYDOID;
                                vXulyDon_new.TRADON_NGAYTRA = vXulyDon_old.TRADON_NGAYTRA;
                                vXulyDon_new.YCBS_NGAYYEUCAU = vXulyDon_old.YCBS_NGAYYEUCAU;
                                vXulyDon_new.YCBS_NOIDUNG = vXulyDon_old.YCBS_NOIDUNG;
                                vXulyDon_new.CDTN_NGAYCHUYEN = vXulyDon_old.CDTN_NGAYCHUYEN;
                                vXulyDon_new.SOTHONGBAO = vXulyDon_old.SOTHONGBAO;
                                vXulyDon_new.FILEID = vXulyDon_old.FILEID;
                                vXulyDon_new.YCBS_THOIHAN = vXulyDon_old.YCBS_THOIHAN;
                                vXulyDon_new.TOAANID = vXulyDon_old.TOAANID;
                                vXulyDon_new.NGAYTHONGBAO = vXulyDon_old.NGAYTHONGBAO;
                                vXulyDon_new.DON_CHITIETID = vXulyDon_old.DON_CHITIETID;
                                vXulyDon_new.DON_XULYID = vXulyDon_old.DON_XULYID;
                                vXulyDon_new.TOA_GIAIQUYET_ID = vXulyDon_old.TOA_GIAIQUYET_ID;
                                dt.AHN_DON_XULY.Add(vXulyDon_new);
                                dt.SaveChanges();
                            }
                            //Tam ung an phi
                            List<AHN_ANPHI> lstAP = dt.AHN_ANPHI.Where(x => x.DONID == DonID && x.MAGIAIDOAN == 2).ToList();
                            foreach (AHN_ANPHI vAP_old in lstAP)
                            {
                                AHN_ANPHI vAP_new = new AHN_ANPHI();
                                vAP_new.DONID = oDON_new.ID;
                                vAP_new.GIATRITRANHCHAP = vAP_old.GIATRITRANHCHAP;
                                vAP_new.MUCGIAMANPHI = vAP_old.MUCGIAMANPHI;
                                vAP_new.TAMUNGANPHI = vAP_old.TAMUNGANPHI;
                                vAP_new.ANPHI = vAP_old.ANPHI;
                                vAP_new.HANNOP = vAP_old.HANNOP;
                                vAP_new.SONGAYGIAHAN = vAP_old.SONGAYGIAHAN;
                                vAP_new.TINHTRANG = vAP_old.TINHTRANG;
                                vAP_new.NGAYNOPANPHI = vAP_old.NGAYNOPANPHI;
                                vAP_new.NGAYNOPBIENLAI = vAP_old.NGAYNOPBIENLAI;
                                vAP_new.SOBIENLAI = vAP_old.SOBIENLAI;
                                vAP_new.NGUOINHANID = vAP_old.NGUOINHANID;
                                vAP_new.GHICHU = vAP_old.GHICHU;
                                vAP_new.NGAYTAO = DateTime.Now;
                                vAP_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                vAP_new.HANNOP_SONGAY = vAP_old.HANNOP_SONGAY;
                                vAP_new.SOTHONGBAO = vAP_old.SOTHONGBAO;
                                vAP_new.NGAYTHONGBAO = vAP_old.NGAYTHONGBAO;
                                vAP_new.NGUOINOP = vAP_old.NGUOINOP;
                                vAP_new.MAGIAIDOAN = vAP_old.MAGIAIDOAN;
                                vAP_new.TOA_GIAIQUYET_ID = vAP_old.TOA_GIAIQUYET_ID;
                                //vAP_new.DUONGSU_ID = vAP_old.DUONGSU_ID; Sử dụng PKG để INSERT
                                // vAP_new.TOA_GIAIQUYET_ID = vAP_old.TOA_GIAIQUYET_ID;
                                dt.AHN_ANPHI.Add(vAP_new);
                                dt.SaveChanges();

                                var CNA = new CHUYEN_NHAN_AN();
                                CNA.INSERT_ANPHI_DUONGSUID(3, DonID, oDON_new.ID);

                            }
                            

                            //MAP_VUANID_NEW
                            oT.MAP_VUANID_NEW = oDON_new.ID;
                        }
                    }
                    else if (oIT.MA == ENUM_TRUONGHOP_GIAONHAN.TOA_CAPCAO_CHUYEN_VE)
                    {
                        byte[] bGuid = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                        // Lưu thông tin liên quan vụ án vào các bảng dữ liệu tương ứng
                        string sql = "select * from HOSO where Guid='" + bGuid + "'";
                        DataTable tblHoSo = Cls_Comon.GetTableToSQL(CONNECTION_TO_DB_TRUNGGIAN, sql);
                        if (tblHoSo.Rows.Count > 0)
                        {
                            DataRow r = tblHoSo.Rows[0];
                            string LoaiAn = r["LOAI_AN"].ToString(),
                                   CapXetXu = r["CAP_XET_XU"].ToString();
                            if (LoaiAn == ENUM_LOAIAN.AN_HONNHAN_GIADINH)
                            {
                                #region Update Nguyên đơn và bị đơn
                                string strList_NguyenBiDon = JsonConvert.SerializeObject(r["NGUOI_THAM_GIA_AK"].ToString());
                                List<NGUOI_THAM_GIA_AK> List_NguyeDon_BiDon = JsonConvert.DeserializeObject<List<NGUOI_THAM_GIA_AK>>(strList_NguyenBiDon);
                                UpdateNguyenDonBiDon(List_NguyeDon_BiDon, DonID);
                                #endregion
                                #region Update người tham gia tố tụng
                                string strList_NguoiTGTT = JsonConvert.SerializeObject(r["NGUOI_THAM_GIA_CHUNG"].ToString());
                                List<NGUOI_THAM_GIA_CHUNG> List_NguoiTGTT = JsonConvert.DeserializeObject<List<NGUOI_THAM_GIA_CHUNG>>(strList_NguoiTGTT);
                                UpdateNguoiTGTT(List_NguoiTGTT, DonID);
                                #endregion
                                #region Update Thụ lý
                                string strThuLy = JsonConvert.SerializeObject(r["THU_LY"].ToString());
                                THU_LY oTHU_LY = JsonConvert.DeserializeObject<THU_LY>(strThuLy);
                                UpdateThuLy(oTHU_LY, (decimal)oT.TOANHANID, DonID, CapXetXu);
                                #endregion
                                #region Update Danh sách người tiến hành tố tụng
                                string strList_NguoiTHTT = JsonConvert.SerializeObject(r["NGUOI_TIEN_HANH_TO_TUNG"].ToString());
                                List<NGUOI_TIEN_HANH_TO_TUNG> List_NguoiTHTT = JsonConvert.DeserializeObject<List<NGUOI_TIEN_HANH_TO_TUNG>>(strList_NguoiTHTT);
                                UpdateNguoiTHTT(List_NguoiTHTT, DonID, CapXetXu);
                                #endregion
                                #region Update Quyết định vụ án
                                string strList_QD = JsonConvert.SerializeObject(r["QUYET_DINH"].ToString());
                                List<QUYET_DINH> List_QD = JsonConvert.DeserializeObject<List<QUYET_DINH>>(strList_QD);
                                UpdateQDVuViec(List_QD, (decimal)oT.TOANHANID, DonID, CapXetXu);
                                #endregion
                                #region Update Bản án
                                string strBanAn = JsonConvert.SerializeObject(r["BAN_AN"].ToString());
                                BAN_AN oBanAn = JsonConvert.DeserializeObject<BAN_AN>(strBanAn);
                                string LichXetXu = JsonConvert.SerializeObject(r["LICH_XET_XU"].ToString());
                                LICH_XET_XU oLichXetXu = JsonConvert.DeserializeObject<LICH_XET_XU>(LichXetXu);
                                UpdateBanAn(oBanAn, oLichXetXu, (decimal)oT.TOANHANID, DonID, CapXetXu);
                                #endregion
                            }
                        }
                        // Update trạng thái là Đã nhận trong bảng HOSO ở DataBase Trung Gian
                        // TRANG_THAI=2: Đã nhận
                        sql = "update HOSO set TRANG_THAI=2 where Guid='" + bGuid + "'";
                        Cls_Comon.ExcuteProc_With_Connection(CONNECTION_TO_DB_TRUNGGIAN, sql);
                    }
                    else if (oIT.MA == ENUM_TRUONGHOP_GIAONHAN.KHONGTHUOC_THAMQUYEN_GIAIQUYET)
                    {
                        /*  Lê Nam
                            Chuyển án không thuộc thẩm quyền
                        */
                        string UserName = Session[ENUM_SESSION.SESSION_USERNAME] + "", LoaiVuViec = ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH, MaToaAn = Session[ENUM_SESSION.SESSION_MADONVI] + "";
                        decimal ToaAnNhan = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
                                DonID_New = Action_ChuyenAn_KhongThuoc_ThamQuyen(DonID, LoaiVuViec, ToaAnNhan, MaToaAn, UserName);

                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        GD.GAIDOAN_INSERT_UPDATE("3", DonID_New, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                    }
                    else
                    {
                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        oDon.TOAPHUCTHAMID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        oDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                        //var soThamKhangCaos = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == oDon.ID && x.LOAIKHANGCAO == 2 && (x.TINHTRANG_GIAIQUYET == null || x.TINHTRANG_GIAIQUYET == 0));
                        //var soThamKhangNghis = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.DONID == oDon.ID && x.LOAIKN == 2 && (x.TINHTRANG_GIAIQUYET == null || x.TINHTRANG_GIAIQUYET == 0));

                        //if ((soThamKhangCaos != null && soThamKhangCaos.Count() > 0) || (soThamKhangNghis != null && soThamKhangNghis.Count() > 0))
                        AHN_CHUYEN_NHAN_AN_BL _chuyenNhanAnBl = new AHN_CHUYEN_NHAN_AN_BL();
                        if (_chuyenNhanAnBl.CheckCoKcKnTamDinhChi(DonID))
                        {
                            #region toancau-anhnt thêm mới đơn pttdc
                            AHN_DON oDON_new = new AHN_DON();
                            oDON_new.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            oDON_new.MAVUVIEC = oDon.MAVUVIEC;
                            oDON_new.TENVUVIEC = oDon.TENVUVIEC;
                            oDON_new.SOTHUTU = oDon.SOTHUTU;
                            // vnpt HOANGNDH 11122025
                            // TH thụ lý xx lại ST thì nhận án PT TH giao nhận "Thụ lý mới"
                            if (oDon.HINHTHUCNHANDON == Convert.ToDecimal(ENUM_TRUONGHOP_GIAONHAN.GDT_HUY_TRA_VE_ST))
                            {
                                oDON_new.HINHTHUCNHANDON = ENUM_GDTTT_TRANGTHAI.THULY_MOI;
                            } else
                            {
                                oDON_new.HINHTHUCNHANDON = oT.TRUONGHOPGIAONHANID;
                            }
                            oDON_new.NGAYVIETDON = oDon.NGAYVIETDON;
                            oDON_new.NGAYNHANDON = oDon.NGAYNHANDON;
                            oDON_new.LOAIQUANHE = oDon.LOAIQUANHE;
                            oDON_new.QUANHEPHAPLUATID = oDon.QUANHEPHAPLUATID;
                            oDON_new.CANBONHANDONID = oDon.CANBONHANDONID;
                            oDON_new.THAMPHANKYNHANDON = oDon.THAMPHANKYNHANDON;
                            oDON_new.YEUTONUOCNGOAI = oDon.YEUTONUOCNGOAI;
                            oDON_new.DONKIENCUANGUOIKHAC = oDon.DONKIENCUANGUOIKHAC;
                            oDON_new.LOAIDON = oDon.LOAIDON;
                            oDON_new.TRANGTHAI = oDon.TRANGTHAI;
                            oDON_new.USERTT_EMAIL = oDon.USERTT_EMAIL;
                            oDON_new.USERTT_ID = oDon.USERTT_ID;
                            oDON_new.USERTT_NGAYTAO = oDon.USERTT_NGAYTAO;
                            oDON_new.USERTT_NGAYGUI = oDon.USERTT_NGAYGUI;
                            oDON_new.USERTT_NGAYBOSUNG = oDon.USERTT_NGAYBOSUNG;

                            oDON_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            oDON_new.NGAYTAO = DateTime.Now;
                            AHN_DON_BL dsBL = new AHN_DON_BL();
                            oDON_new.TT = dsBL.GETNEWTT((decimal)oDON_new.TOAANID);

                            oDON_new.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM_QDK;
                            oDON_new.NOIDUNGKHOIKIEN = oDon.NOIDUNGKHOIKIEN;
                            oDON_new.MABAOMAT = oDon.MABAOMAT;
                            oDON_new.LYDOLYHONID = oDon.LYDOLYHONID;
                            oDON_new.SOCONCHUATHANHNIEN = oDon.SOCONCHUATHANHNIEN;
                            oDON_new.TOAPHUCTHAMID = oDon.TOAPHUCTHAMID;
                            oDON_new.QHPLTKID = oDon.QHPLTKID;
                            oDON_new.SOCONDUOI7TUOI = oDon.SOCONDUOI7TUOI;
                            oDON_new.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                            oDON_new.QUANHEPHAPLUAT_NAME = oDon.QUANHEPHAPLUAT_NAME;
                            //oDON_new.TENVUVIEC_PT = oDon.TENVUVIEC_PT;
                            oDON_new.DONID_TOACU = oDon.DONID_TOACU;
                            oDON_new.TOA_GIAIQUYET_ID = oDon.TOA_GIAIQUYET_ID;
                            dt.AHN_DON.Add(oDON_new);
                            dt.SaveChanges();
                            GD.GAIDOAN_INSERT_UPDATE("3", oDON_new.ID, ENUM_GIAIDOANVUAN.PHUCTHAM_QDK, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);

                            IQueryable<DON_CHITIET> lstDON_CHITIET = dt.DON_CHITIET.Where(s => s.DONID == oDon.ID);
                            var listDOnCT = new List<KeyValuePair<decimal, decimal>>();
                            foreach (var it in lstDON_CHITIET)
                            {
                                DON_CHITIET oKC = new DON_CHITIET();

                                oKC.DONID = oDON_new.ID;
                                oKC.LOAIANID = it.LOAIANID;
                                oKC.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                oKC.HINHTHUCNHANDON = it.HINHTHUCNHANDON;
                                oKC.NGAYVIETDON = it.NGAYVIETDON;
                                oKC.NGAYNHANDON = it.NGAYNHANDON;
                                oKC.CANBONHANDONID = it.CANBONHANDONID;
                                oKC.THAMPHANKYNHANDON = it.THAMPHANKYNHANDON;
                                oKC.YEUTONUOCNGOAI = it.YEUTONUOCNGOAI;
                                oKC.LOAIDON = it.LOAIDON;
                                oKC.USERTT_EMAIL = it.USERTT_EMAIL;
                                oKC.USERTT_ID = it.USERTT_ID;
                                oKC.USERTT_NGAYTAO = it.USERTT_NGAYTAO;
                                oKC.USERTT_NGAYGUI = it.USERTT_NGAYGUI;
                                oKC.USERTT_NGAYBOSUNG = it.USERTT_NGAYBOSUNG;
                                oKC.NGUOITAO = it.NGUOITAO;
                                oKC.NGAYTAO = it.NGAYTAO;
                                oKC.NGUOISUA = it.NGUOISUA;
                                oKC.NGAYSUA = it.NGAYSUA;
                                oKC.NOIDUNGKHOIKIEN = it.NOIDUNGKHOIKIEN;
                                oKC.THONGTINTHEM = it.THONGTINTHEM;
                                oKC.DONKKID = it.DONKKID;
                                oKC.GHICHU = it.GHICHU;
                                oKC.TTGQ = it.TTGQ;
                                oKC.NOIDUNGTTGQ = it.NOIDUNGTTGQ;
                                oKC.DONGUINHANID = it.DONGUINHANID;
                                oKC.IS_NHAPAN = it.IS_NHAPAN;
                                oKC.TOA_GIAIQUYET_ID = it.TOA_GIAIQUYET_ID;
                                dt.DON_CHITIET.Add(oKC);
                                dt.SaveChanges();

                                listDOnCT.Add(new KeyValuePair<decimal, decimal>(it.ID, oKC.ID));
                            }
                            //Câp dương su vụ án
                            List<AHN_DON_DUONGSU> lst = dt.AHN_DON_DUONGSU.Where(x => x.DONID == DonID).ToList<AHN_DON_DUONGSU>();
                            foreach (AHN_DON_DUONGSU vDuongsu_old in lst)
                            {
                                AHN_DON_DUONGSU vDuongsu_new = new AHN_DON_DUONGSU();

                                vDuongsu_new.DONID = oDON_new.ID;
                                vDuongsu_new.MADUONGSU = vDuongsu_old.MADUONGSU;
                                vDuongsu_new.TENDUONGSU = vDuongsu_old.TENDUONGSU;
                                vDuongsu_new.ISDAIDIEN = vDuongsu_old.ISDAIDIEN;
                                vDuongsu_new.TUCACHTOTUNG_MA = vDuongsu_old.TUCACHTOTUNG_MA;
                                vDuongsu_new.LOAIDUONGSU = vDuongsu_old.LOAIDUONGSU;
                                vDuongsu_new.SOCMND = vDuongsu_old.SOCMND;
                                vDuongsu_new.QUOCTICHID = vDuongsu_old.QUOCTICHID;
                                vDuongsu_new.TAMTRUID = vDuongsu_old.TAMTRUID;
                                vDuongsu_new.TAMTRUCHITIET = vDuongsu_old.TAMTRUCHITIET;
                                vDuongsu_new.HKTTID = vDuongsu_old.HKTTID;
                                vDuongsu_new.HKTTCHITIET = vDuongsu_old.HKTTCHITIET;
                                vDuongsu_new.NGAYSINH = vDuongsu_old.NGAYSINH;
                                vDuongsu_new.THANGSINH = vDuongsu_old.THANGSINH;
                                vDuongsu_new.NAMSINH = vDuongsu_old.NAMSINH;
                                vDuongsu_new.GIOITINH = vDuongsu_old.GIOITINH;
                                vDuongsu_new.NGUOIDAIDIEN = vDuongsu_old.NGUOIDAIDIEN;
                                vDuongsu_new.CHUCVU = vDuongsu_old.CHUCVU;
                                vDuongsu_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                vDuongsu_new.NGAYTAO = DateTime.Now;
                                vDuongsu_new.NDD_DIACHIID = vDuongsu_old.NDD_DIACHIID;
                                vDuongsu_new.NDD_DIACHICHITIET = vDuongsu_old.NDD_DIACHICHITIET;
                                vDuongsu_new.ISSOTHAM = vDuongsu_old.ISSOTHAM;
                                vDuongsu_new.ISPHUCTHAM = vDuongsu_old.ISPHUCTHAM;
                                vDuongsu_new.ISGDT = vDuongsu_old.ISGDT;
                                vDuongsu_new.ISDON = vDuongsu_old.ISDON;
                                vDuongsu_new.EMAIL = vDuongsu_old.EMAIL;
                                vDuongsu_new.DIENTHOAI = vDuongsu_old.DIENTHOAI;
                                vDuongsu_new.FAX = vDuongsu_old.FAX;
                                vDuongsu_new.SINHSONG_NUOCNGOAI = vDuongsu_old.SINHSONG_NUOCNGOAI;
                                vDuongsu_new.HKTTTINHID = vDuongsu_old.HKTTTINHID;
                                vDuongsu_new.TAMTRUTINHID = vDuongsu_old.TAMTRUTINHID;
                                vDuongsu_new.DIACHICOQUAN = vDuongsu_old.DIACHICOQUAN;
                                vDuongsu_new.ID_DUONGSU_TACC = vDuongsu_old.ID_DUONGSU_TACC;
                                vDuongsu_new.ISDONCHITIET = vDuongsu_old.ISDONCHITIET;
                                vDuongsu_new.ISDAIDIEN_DONCHITIET = vDuongsu_old.ISDAIDIEN_DONCHITIET;
                                vDuongsu_new.TOA_GIAIQUYET_ID = vDuongsu_old.TOA_GIAIQUYET_ID;
                                // vnpt 06/12/2025
                                vDuongsu_new.XACTHUC_DLDCQG = vDuongsu_old.XACTHUC_DLDCQG;
                                dt.AHN_DON_DUONGSU.Add(vDuongsu_new);
                                dt.SaveChanges();

                                IQueryable<DON_DUONGSU_CHITIET> lstDON_DUONGSU_CHITIET = dt.DON_DUONGSU_CHITIET.Where(s => s.DONID == oDon.ID && s.DUONGSUID == vDuongsu_old.ID);
                                foreach (var itDSCT in lstDON_DUONGSU_CHITIET)
                                {
                                    DON_DUONGSU_CHITIET oKC = new DON_DUONGSU_CHITIET();
                                    oKC.DONID = oDON_new.ID;
                                    oKC.DUONGSUID = vDuongsu_new.ID;
                                    oKC.LOAIAN = itDSCT.LOAIAN;
                                    foreach (var itemDonCTId in listDOnCT)
                                    {
                                        if (itemDonCTId.Key == itDSCT.DONCHITIETID)
                                        {
                                            oKC.DONCHITIETID = itemDonCTId.Value;
                                        }
                                    }
                                    oKC.NGUOITAO = itDSCT.NGUOITAO;
                                    oKC.NGAYTAO = itDSCT.NGAYTAO;
                                    oKC.NGUOISUA = itDSCT.NGUOISUA;
                                    oKC.NGAYSUA = itDSCT.NGAYSUA;
                                    oKC.TOA_GIAIQUYET_ID = itDSCT.TOA_GIAIQUYET_ID;
                                    dt.DON_DUONGSU_CHITIET.Add(oKC);
                                    dt.SaveChanges();
                                }

                                //Ban giao tai lieu
                                List<AHN_DON_TAILIEU> lstTaiLieu = dt.AHN_DON_TAILIEU.Where(x => x.DONID == DonID && x.NGUOIBANGIAO == vDuongsu_old.ID).ToList<AHN_DON_TAILIEU>();
                                foreach (AHN_DON_TAILIEU vdonFile_old in lstTaiLieu)
                                {
                                    AHN_DON_TAILIEU donFile_new = new AHN_DON_TAILIEU();
                                    donFile_new.DONID = oDON_new.ID;
                                    donFile_new.TENTAILIEU = vdonFile_old.TENTAILIEU;
                                    donFile_new.TENFILE = vdonFile_old.TENFILE;
                                    donFile_new.LOAIFILE = vdonFile_old.LOAIFILE;
                                    donFile_new.NOIDUNG = vdonFile_old.NOIDUNG;
                                    donFile_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    donFile_new.NGAYTAO = DateTime.Now;
                                    donFile_new.BANGIAOID = vdonFile_old.BANGIAOID;
                                    donFile_new.NGAYBANGIAO = vdonFile_old.NGAYBANGIAO;
                                    donFile_new.NGUOIBANGIAO = vDuongsu_new.ID; //Luu duong su moi
                                    donFile_new.LOAIDOITUONG = vdonFile_old.LOAIDOITUONG;
                                    donFile_new.NGUOINHANID = vdonFile_old.NGUOINHANID;
                                    donFile_new.TOA_GIAIQUYET_ID = vdonFile_old.TOA_GIAIQUYET_ID;
                                    dt.AHN_DON_TAILIEU.Add(donFile_new);
                                    dt.SaveChanges();
                                }
                            }

                            // Phan cong Tham phan
                            List<AHN_DON_THAMPHAN> lstThamPhan = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).ToList<AHN_DON_THAMPHAN>();
                            foreach (AHN_DON_THAMPHAN vThamphan_old in lstThamPhan)
                            {
                                AHN_DON_THAMPHAN vThamphan_new = new AHN_DON_THAMPHAN();
                                vThamphan_new.DONID = oDON_new.ID;
                                vThamphan_new.CANBOID = vThamphan_old.CANBOID;
                                vThamphan_new.MAVAITRO = vThamphan_old.MAVAITRO;
                                vThamphan_new.NGAYPHANCONG = vThamphan_old.NGAYPHANCONG;
                                vThamphan_new.NGAYNHANPHANCONG = vThamphan_old.NGAYNHANPHANCONG;
                                vThamphan_new.NGAYTHAMGIA = vThamphan_old.NGAYTHAMGIA;
                                vThamphan_new.NGAYKETTHUC = vThamphan_old.NGAYKETTHUC;
                                vThamphan_new.NGUOIPHANCONGID = vThamphan_old.NGUOIPHANCONGID;
                                vThamphan_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                vThamphan_new.NGAYTAO = DateTime.Now;
                                vThamphan_new.ID_PHAN_CONG_AN = vThamphan_old.ID_PHAN_CONG_AN;
                                vThamphan_new.THUKYID = vThamphan_old.THUKYID;
                                vThamphan_new.TOA_GIAIQUYET_ID = vThamphan_old.TOA_GIAIQUYET_ID;
                                dt.AHN_DON_THAMPHAN.Add(vThamphan_new);
                                dt.SaveChanges();
                            }
                            //Xu ly don
                            List<AHN_DON_XULY> lstXulyDon = dt.AHN_DON_XULY.Where(x => x.DONID == DonID).ToList<AHN_DON_XULY>();
                            foreach (AHN_DON_XULY vXulyDon_old in lstXulyDon)
                            {
                                AHN_DON_XULY vXulyDon_new = new AHN_DON_XULY();
                                vXulyDon_new.DONID = oDON_new.ID;
                                vXulyDon_new.LOAIGIAIQUYET = vXulyDon_old.LOAIGIAIQUYET;
                                vXulyDon_new.NGAYGQ_YC = vXulyDon_old.NGAYGQ_YC;
                                vXulyDon_new.LYDO = vXulyDon_old.LYDO;
                                vXulyDon_new.CDTN_TOAANID = vXulyDon_old.CDTN_TOAANID;
                                vXulyDon_new.CDTN_NGAYNHAN = vXulyDon_old.CDTN_NGAYNHAN;
                                vXulyDon_new.CDNN_TENCQ = vXulyDon_old.CDNN_TENCQ;
                                vXulyDon_new.TRADON_CANCUID = vXulyDon_old.TRADON_CANCUID;
                                vXulyDon_new.NGAYTAO = DateTime.Now;
                                vXulyDon_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                vXulyDon_new.CDNN_NGAYCHUYEN = vXulyDon_old.CDNN_NGAYCHUYEN;
                                vXulyDon_new.TRADON_LYDOID = vXulyDon_old.TRADON_LYDOID;
                                vXulyDon_new.TRADON_NGAYTRA = vXulyDon_old.TRADON_NGAYTRA;
                                vXulyDon_new.YCBS_NGAYYEUCAU = vXulyDon_old.YCBS_NGAYYEUCAU;
                                vXulyDon_new.YCBS_NOIDUNG = vXulyDon_old.YCBS_NOIDUNG;
                                vXulyDon_new.CDTN_NGAYCHUYEN = vXulyDon_old.CDTN_NGAYCHUYEN;
                                vXulyDon_new.SOTHONGBAO = vXulyDon_old.SOTHONGBAO;
                                vXulyDon_new.FILEID = vXulyDon_old.FILEID;
                                vXulyDon_new.YCBS_THOIHAN = vXulyDon_old.YCBS_THOIHAN;
                                vXulyDon_new.TOAANID = vXulyDon_old.TOAANID;
                                vXulyDon_new.NGAYTHONGBAO = vXulyDon_old.NGAYTHONGBAO;
                                vXulyDon_new.DON_CHITIETID = vXulyDon_old.DON_CHITIETID;
                                vXulyDon_new.DON_XULYID = vXulyDon_old.DON_XULYID;
                                vXulyDon_new.TOA_GIAIQUYET_ID = vXulyDon_old.TOA_GIAIQUYET_ID;
                                dt.AHN_DON_XULY.Add(vXulyDon_new);
                                dt.SaveChanges();
                            }
                            //Tam ung an phi
                            List<AHN_ANPHI> lstAP = dt.AHN_ANPHI.Where(x => x.DONID == DonID && x.MAGIAIDOAN == 2).ToList();
                            foreach (AHN_ANPHI vAP_old in lstAP)
                            {
                                AHN_ANPHI vAP_new = new AHN_ANPHI();
                                vAP_new.DONID = oDON_new.ID;
                                vAP_new.GIATRITRANHCHAP = vAP_old.GIATRITRANHCHAP;
                                vAP_new.MUCGIAMANPHI = vAP_old.MUCGIAMANPHI;
                                vAP_new.TAMUNGANPHI = vAP_old.TAMUNGANPHI;
                                vAP_new.ANPHI = vAP_old.ANPHI;
                                vAP_new.HANNOP = vAP_old.HANNOP;
                                vAP_new.SONGAYGIAHAN = vAP_old.SONGAYGIAHAN;
                                vAP_new.TINHTRANG = vAP_old.TINHTRANG;
                                vAP_new.NGAYNOPANPHI = vAP_old.NGAYNOPANPHI;
                                vAP_new.NGAYNOPBIENLAI = vAP_old.NGAYNOPBIENLAI;
                                vAP_new.SOBIENLAI = vAP_old.SOBIENLAI;
                                vAP_new.NGUOINHANID = vAP_old.NGUOINHANID;
                                vAP_new.GHICHU = vAP_old.GHICHU;
                                vAP_new.NGAYTAO = DateTime.Now;
                                vAP_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                vAP_new.HANNOP_SONGAY = vAP_old.HANNOP_SONGAY;
                                vAP_new.SOTHONGBAO = vAP_old.SOTHONGBAO;
                                vAP_new.NGAYTHONGBAO = vAP_old.NGAYTHONGBAO;
                                vAP_new.NGUOINOP = vAP_old.NGUOINOP;
                                vAP_new.TOA_GIAIQUYET_ID = vAP_old.TOA_GIAIQUYET_ID;
                                //vAP_new.DUONGSU_ID = vAP_old.DUONGSU_ID; Sử dụng PKG để INSERT
                                dt.AHN_ANPHI.Add(vAP_new);
                                dt.SaveChanges();

                                var CNA = new CHUYEN_NHAN_AN();
                                CNA.INSERT_ANPHI_DUONGSUID(3, DonID, oDON_new.ID);
                            }

                            //MAP_VUANID_NEW
                            oT.MAP_VUANID_NEW = oDON_new.ID;
                            #endregion toancau-anhnt thêm mới đơn pttdc
                        }
                        else
                        {
                            oDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                            oDon.TOAPHUCTHAMID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.SaveChanges();
                            //anhvh add 26/06/2020

                            GD.GAIDOAN_INSERT_UPDATE("3", DonID, 3, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
                        }
                    }
                    oT.TRANGTHAI = 1;// 0: Chuyển chờ nhận, 1: Nhận
                    oT.NGAYGIAO = String.IsNullOrEmpty(txtN_Ngaygiao.Text.Trim()) ? (DateTime?)null : DateTime.Parse(txtN_Ngaygiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.NGAYNHAN = String.IsNullOrEmpty(txtNgayNhan.Text.Trim()) ? (DateTime?)null : DateTime.Parse(txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.NGUOINHANID = Convert.ToDecimal(ddlN_Nguoinhan.SelectedValue);
                    oT.NGUOITAO_PHUCTHAM = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.NGAYTAO_PHUCTHAM = DateTime.Now;
                    oT.NGAYSUA = DateTime.Now;
                    dt.SaveChanges();

                }
            }

            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            lbthongbaoNA.Text = "Nhận án thành công !";
            pnDanhsach.Visible = true;
            pnCapnhat.Visible = false;

        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            pnDanhsach.Visible = true;
            pnCapnhat.Visible = false;
        }
        protected void rdbTrangthai_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #region Phần lưu thông tin vụ án, vụ việc từ tòa cấp cao
        private void UpdateNguyenDonBiDon(List<NGUOI_THAM_GIA_AK> List_NguyeDon_BiDon, decimal DonID)
        {
            if (List_NguyeDon_BiDon.Count > 0)
            {
                bool IsNew = false;
                foreach (NGUOI_THAM_GIA_AK item in List_NguyeDon_BiDon)
                {
                    IsNew = false;
                    AHN_DON_DUONGSU DuongSu = dt.AHN_DON_DUONGSU.Where(x => x.DONID == DonID && x.ID_DUONGSU_TACC == item.Guid).FirstOrDefault();
                    if (DuongSu == null)
                    {
                        IsNew = true;
                        DuongSu = new AHN_DON_DUONGSU();
                    }
                    DuongSu.TENDUONGSU = item.TENDUONGSU;
                    DuongSu.SOCMND = item.CMND;
                    DateTime NgaySinh = DateTime.MinValue;
                    if (DateTime.TryParseExact(item.NGAYSINH, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgaySinh))
                    {
                        DuongSu.NGAYSINH = NgaySinh;
                    }
                    DuongSu.NAMSINH = item.NAMSINH + "" == "" ? 0 : Convert.ToDecimal(item.NAMSINH);
                    DuongSu.GIOITINH = item.GIOITINH + "" == "" ? 0 : Convert.ToDecimal(item.GIOITINH);
                    DM_DATAGROUP GQuocTich = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.QUOCTICH).FirstOrDefault();
                    if (GQuocTich != null)
                    {
                        DM_DATAITEM QuocTich = dt.DM_DATAITEM.Where(x => x.GROUPID == GQuocTich.ID && x.MA == item.QUOCTICH).FirstOrDefault();
                        if (QuocTich != null)
                        {
                            DuongSu.QUOCTICHID = QuocTich.ID;
                        }
                    }
                    DuongSu.TAMTRUTINHID = item.MA_TINH + "" == "" ? 0 : Convert.ToDecimal(item.MA_TINH);
                    DuongSu.TAMTRUID = item.MA_HUYEN + "" == "" ? 0 : Convert.ToDecimal(item.MA_HUYEN);
                    DuongSu.TAMTRUCHITIET = item.DIACHICHITIET;
                    switch (item.LOAIDUONGSU + "")
                    {
                        case "CANHAN":
                            DuongSu.LOAIDUONGSU = 1;
                            break;
                        case "COQUAN":
                            DuongSu.LOAIDUONGSU = 2;
                            break;
                        case "TOCHUC":
                            DuongSu.LOAIDUONGSU = 3;
                            break;
                    }
                    DuongSu.NGUOIDAIDIEN = item.NGUOIDAIDIEN;
                    DuongSu.TUCACHTOTUNG_MA = item.TUCACHTOTUNG;
                    if (IsNew)
                    {
                        //DuongSu.TOA_GIAIQUYET_ID = item.TOA_GIAIQUYET_ID; // an hn
                        if (DuongSu.TOA_GIAIQUYET_ID == null)
                            DuongSu.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.AHN_DON_DUONGSU.Add(DuongSu);
                    }
                    dt.SaveChanges();
                }
            }
        }
        private void UpdateNguoiTGTT(List<NGUOI_THAM_GIA_CHUNG> ListNguoiTGTT, decimal DonID)
        {
            if (ListNguoiTGTT.Count > 0)
            {
                bool IsNew = false;
                foreach (NGUOI_THAM_GIA_CHUNG item in ListNguoiTGTT)
                {
                    AHN_DON_THAMGIATOTUNG NguoiTGTT = dt.AHN_DON_THAMGIATOTUNG.Where(x => x.DONID == DonID && x.ID_DUONGSU_TACC == item.Guid).FirstOrDefault();
                    if (NguoiTGTT != null)
                    {
                        IsNew = true;
                        NguoiTGTT = new AHN_DON_THAMGIATOTUNG();
                        NguoiTGTT.NGAYTAO = DateTime.Now;
                    }
                    else
                    {
                        NguoiTGTT.NGAYSUA = DateTime.Now;
                    }
                    NguoiTGTT.DONID = DonID;
                    NguoiTGTT.ID_DUONGSU_TACC = item.Guid;
                    NguoiTGTT.HOTEN = item.TENDUONGSU;
                    DateTime NgaySinh = DateTime.MinValue;
                    if (DateTime.TryParseExact(item.NGAYSINH, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgaySinh))
                    {
                        NguoiTGTT.NGAYSINH = NgaySinh;
                    }
                    else
                    {
                        NguoiTGTT.NGAYSINH = (DateTime?)null;
                    }
                    NguoiTGTT.NAMSINH = item.NAMSINH + "" == "" ? 0 : Convert.ToDecimal(item.NAMSINH);
                    NguoiTGTT.GIOITINH = item.GIOITINH;
                    NguoiTGTT.TUCACHTGTTID = item.TUCACHTOTUNG;
                    if (IsNew)
                    {
                        //NguoiTGTT.TOA_GIAIQUYET_ID = item.TOA_GIAIQUYET_ID;
                        
                        // an hn
                        if (NguoiTGTT.TOA_GIAIQUYET_ID == null)
                            NguoiTGTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        
                        dt.AHN_DON_THAMGIATOTUNG.Add(NguoiTGTT);
                    }
                    dt.SaveChanges();
                }
            }
        }
        private void UpdateThuLy(THU_LY ThuLy, decimal ToaAnID, decimal DonID, string CapXetXu)
        {
            if (CapXetXu == "SOTHAM")
            {
                // Update thụ lý sơ thẩm
                bool IsNew = false;
                AHN_SOTHAM_THULY STThuLy = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == DonID && x.SOTHULY == ThuLy.SOTHULY.ToString()).FirstOrDefault();
                if (STThuLy != null)
                {
                    IsNew = true;
                    STThuLy = new AHN_SOTHAM_THULY();
                    STThuLy.NGAYTAO = DateTime.Now;
                }
                else
                {
                    STThuLy.NGAYSUA = DateTime.Now;
                }
                STThuLy.DONID = DonID;
                STThuLy.SOTHULY = ThuLy.SOTHULY.ToString();
                DateTime NgayThuLy = DateTime.MinValue;
                if (DateTime.TryParseExact(ThuLy.NGAYTHULY, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayThuLy))
                {
                    STThuLy.NGAYTHULY = NgayThuLy;
                }
                else
                {
                    STThuLy.NGAYTHULY = (DateTime?)null;
                }
                DM_DATAGROUP G_THULY = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.TRUONGHOPTHULYAN).FirstOrDefault();
                if (G_THULY != null)
                {
                    DM_DATAITEM TH_ThuLy = dt.DM_DATAITEM.Where(x => x.GROUPID == G_THULY.ID && x.MA == "TOA_KHAC_CHUYEN_DEN").FirstOrDefault();
                    if (TH_ThuLy != null)
                    {
                        STThuLy.TRUONGHOPTHULY = TH_ThuLy.ID;
                    }
                }
                
                if (IsNew)
                {
                    if (STThuLy.TOA_GIAIQUYET_ID == null)
                        STThuLy.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHN_SOTHAM_THULY.Add(STThuLy);
                }
                dt.SaveChanges();
            }
            else
            {
                // Update thụ lý phúc thẩm
                bool IsNew = false;
                AHN_PHUCTHAM_THULY PTThuLy = dt.AHN_PHUCTHAM_THULY.Where(x => x.DONID == DonID && x.SOTHULY == ThuLy.SOTHULY.ToString()).FirstOrDefault();
                if (PTThuLy != null)
                {
                    IsNew = true;
                    PTThuLy = new AHN_PHUCTHAM_THULY();
                    PTThuLy.NGAYTAO = DateTime.Now;
                }
                else
                {
                    PTThuLy.NGAYSUA = DateTime.Now;
                }
                PTThuLy.DONID = DonID;
                PTThuLy.SOTHULY = ThuLy.SOTHULY.ToString();
                DM_DATAGROUP G_THULY = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.TRUONGHOPTHULYAN).FirstOrDefault();
                if (G_THULY != null)
                {
                    DM_DATAITEM TH_ThuLy = dt.DM_DATAITEM.Where(x => x.GROUPID == G_THULY.ID && x.MA == "TOA_KHAC_CHUYEN_DEN").FirstOrDefault();
                    if (TH_ThuLy != null)
                    {
                        PTThuLy.TRUONGHOPTHULY = TH_ThuLy.ID;
                    }
                }
                DateTime NgayThuLy = DateTime.MinValue;
                if (DateTime.TryParseExact(ThuLy.NGAYTHULY, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayThuLy))
                {
                    PTThuLy.NGAYTHULY = NgayThuLy;
                }
                else
                {
                    PTThuLy.NGAYTHULY = (DateTime?)null;
                }
                PTThuLy.TOAANID = ToaAnID;
                if (IsNew)
                {
                    // an hn
                    if (PTThuLy.TOA_GIAIQUYET_ID == null) 
                        PTThuLy.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    
                    dt.AHN_PHUCTHAM_THULY.Add(PTThuLy);
                }
                dt.SaveChanges();
            }
        }
        private void UpdateNguoiTHTT(List<NGUOI_TIEN_HANH_TO_TUNG> ListNguoiTHTT, decimal DonID, string CapXetXu)
        {
            if (ListNguoiTHTT.Count > 0)
            {
                bool IsNew = false;
                foreach (NGUOI_TIEN_HANH_TO_TUNG item in ListNguoiTHTT)
                {
                    decimal CanBoID = item.MACANBO + "" == "" ? 0 : Convert.ToDecimal(item.MACANBO);
                    if (CapXetXu == "SOTHAM")
                    {
                        AHN_SOTHAM_HDXX Hdxx = dt.AHN_SOTHAM_HDXX.Where(x => x.DONID == DonID && x.CANBOID == CanBoID).FirstOrDefault();
                        if (Hdxx == null)
                        {
                            IsNew = true;
                            Hdxx = new AHN_SOTHAM_HDXX();
                            Hdxx.NGAYTAO = DateTime.Now;
                        }
                        else
                        {
                            Hdxx.NGAYSUA = DateTime.Now;
                        }
                        Hdxx.DONID = DonID;
                        Hdxx.CANBOID = CanBoID;
                        Hdxx.HOTEN = item.TENCANBO;
                        Hdxx.MAVAITRO = item.TUCACHTOTUNG;
                        if (IsNew)
                        {
                            if (Hdxx.TOA_GIAIQUYET_ID == null)
                                Hdxx.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            
                            dt.AHN_SOTHAM_HDXX.Add(Hdxx);
                        }
                    }
                    // Phúc thẩm
                    else
                    {
                        AHN_PHUCTHAM_HDXX Hdxx = dt.AHN_PHUCTHAM_HDXX.Where(x => x.DONID == DonID && x.CANBOID == CanBoID).FirstOrDefault();
                        if (Hdxx == null)
                        {
                            IsNew = true;
                            Hdxx = new AHN_PHUCTHAM_HDXX();
                            Hdxx.NGAYTAO = DateTime.Now;
                        }
                        else
                        {
                            Hdxx.NGAYSUA = DateTime.Now;
                        }
                        Hdxx.DONID = DonID;
                        Hdxx.CANBOID = CanBoID;
                        Hdxx.HOTEN = item.TENCANBO;
                        Hdxx.MAVAITRO = item.TUCACHTOTUNG;
                        if (IsNew)
                        {
                            // an hn
                            if (Hdxx.TOA_GIAIQUYET_ID == null) 
                                Hdxx.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            
                            dt.AHN_PHUCTHAM_HDXX.Add(Hdxx);
                        }
                    }
                    dt.SaveChanges();
                }
            }
        }
        private void UpdateQDVuViec(List<QUYET_DINH> ListQD, decimal ToaAnID, decimal DonID, string CapXetXu)
        {
            if (ListQD.Count > 0)
            {
                bool IsNew = false;
                foreach (QUYET_DINH item in ListQD)
                {
                    decimal NguoiKyID = item.NGUOIKY + "" == "" ? 0 : Convert.ToDecimal(item.NGUOIKY);
                    if (CapXetXu == "SOTHAM")
                    {
                        AHN_SOTHAM_QUYETDINH QdVuAn = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.DONID == DonID && x.TOAANID == ToaAnID).FirstOrDefault();
                        if (QdVuAn == null)
                        {
                            IsNew = false;
                            QdVuAn = new AHN_SOTHAM_QUYETDINH()
                            {
                                NGAYTAO = DateTime.Now
                            };
                        }
                        else
                        {
                            QdVuAn.NGAYSUA = DateTime.Now;
                        }
                        decimal QDID = item.MAQUYETDINH + "" == "" ? 0 : Convert.ToDecimal(item.MAQUYETDINH),
                                LoaiQDID = 0;
                        DM_QD_QUYETDINH objQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == QDID).FirstOrDefault();
                        if (objQD != null)
                        {
                            LoaiQDID = (decimal)objQD.LOAIID;
                        }
                        QdVuAn.DONID = DonID;
                        QdVuAn.LOAIQDID = LoaiQDID;
                        QdVuAn.QUYETDINHID = QDID;
                        QdVuAn.TOAANID = ToaAnID;
                        QdVuAn.SOQD = item.SOQUYETDINH;
                        DateTime NgayQD = DateTime.MinValue;
                        if (DateTime.TryParseExact(item.NGAYQUYETDINH, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayQD))
                        {
                            QdVuAn.NGAYQD = NgayQD;
                        }
                        QdVuAn.NGUOIKYID = NguoiKyID;
                        
                        if (QdVuAn.TOA_GIAIQUYET_ID == null)
                            QdVuAn.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        
                        if (IsNew)
                        {
                            dt.AHN_SOTHAM_QUYETDINH.Add(QdVuAn);
                        }
                        dt.SaveChanges();
                    }
                    // Phúc thẩm
                    else
                    {
                        AHN_PHUCTHAM_QUYETDINH QdVuAn = dt.AHN_PHUCTHAM_QUYETDINH.Where(x => x.DONID == DonID && x.TOAANID == ToaAnID).FirstOrDefault();
                        if (QdVuAn == null)
                        {
                            IsNew = false;
                            QdVuAn = new AHN_PHUCTHAM_QUYETDINH()
                            {
                                NGAYTAO = DateTime.Now
                            };
                        }
                        else
                        {
                            QdVuAn.NGAYSUA = DateTime.Now;
                        }
                        decimal QDID = item.MAQUYETDINH + "" == "" ? 0 : Convert.ToDecimal(item.MAQUYETDINH),
                                LoaiQDID = 0;
                        DM_QD_QUYETDINH objQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == QDID).FirstOrDefault();
                        if (objQD != null)
                        {
                            LoaiQDID = (decimal)objQD.LOAIID;
                        }
                        QdVuAn.DONID = DonID;
                        QdVuAn.LOAIQDID = LoaiQDID;
                        QdVuAn.QUYETDINHID = QDID;
                        QdVuAn.TOAANID = ToaAnID;
                        QdVuAn.SOQD = item.SOQUYETDINH;
                        DateTime NgayQD = DateTime.MinValue;
                        if (DateTime.TryParseExact(item.NGAYQUYETDINH, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayQD))
                        {
                            QdVuAn.NGAYQD = NgayQD;
                        }
                        QdVuAn.NGUOIKYID = NguoiKyID;
                        if (IsNew)
                        {
                            // an hn
                            if (QdVuAn.TOA_GIAIQUYET_ID == null) 
                                QdVuAn.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            
                            dt.AHN_PHUCTHAM_QUYETDINH.Add(QdVuAn);
                        }
                        dt.SaveChanges();
                    }
                }
            }
        }
        private void UpdateBanAn(BAN_AN bAn, LICH_XET_XU LichXetXu, decimal ToaAnID, decimal DonID, string CapXetXu)
        {
            bool IsNew = false;
            if (CapXetXu == "SOTHAM")
            {
                AHN_SOTHAM_BANAN STBanAn = dt.AHN_SOTHAM_BANAN.Where(x => x.DONID == DonID && x.TOAANID == ToaAnID).FirstOrDefault();
                if (STBanAn == null)
                {
                    IsNew = true;
                    STBanAn = new AHN_SOTHAM_BANAN();
                    STBanAn.NGAYTAO = DateTime.Now;
                }
                else
                {
                    STBanAn.NGAYSUA = DateTime.Now;
                }
                STBanAn.DONID = DonID;
                STBanAn.TOAANID = ToaAnID;
                STBanAn.SOBANAN = bAn.SOBANAN;
                DateTime NgayBanAn = DateTime.MinValue, NgayXetXu = DateTime.MinValue;
                if (DateTime.TryParseExact(bAn.NGAYBANAN, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayBanAn))
                {
                    STBanAn.NGAYTUYENAN = NgayBanAn;
                }
                if (DateTime.TryParseExact(LichXetXu.NGAYXETXU, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayXetXu))
                {
                    STBanAn.NGAYMOPHIENTOA = NgayXetXu;
                }
                if (IsNew)
                {
                    if (STBanAn.TOA_GIAIQUYET_ID == null)
                        STBanAn.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    
                    dt.AHN_SOTHAM_BANAN.Add(STBanAn);
                }
                dt.SaveChanges();
            }
            // Phúc thẩm
            else
            {
                AHN_PHUCTHAM_BANAN PTBanAn = dt.AHN_PHUCTHAM_BANAN.Where(x => x.DONID == DonID && x.TOAANID == ToaAnID).FirstOrDefault();
                if (PTBanAn == null)
                {
                    IsNew = true;
                    PTBanAn = new AHN_PHUCTHAM_BANAN();
                    PTBanAn.NGAYTAO = DateTime.Now;
                }
                else
                {
                    PTBanAn.NGAYSUA = DateTime.Now;
                }
                PTBanAn.DONID = DonID;
                PTBanAn.TOAANID = ToaAnID;
                PTBanAn.SOBANAN = bAn.SOBANAN;
                DateTime NgayBanAn = DateTime.MinValue, NgayXetXu = DateTime.MinValue;
                if (DateTime.TryParseExact(bAn.NGAYBANAN, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayBanAn))
                {
                    PTBanAn.NGAYTUYENAN = NgayBanAn;
                }
                if (DateTime.TryParseExact(LichXetXu.NGAYXETXU, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayXetXu))
                {
                    PTBanAn.NGAYMOPHIENTOA = NgayXetXu;
                }
                DM_KETQUA_PHUCTHAM KQPT = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ISAHN == 1 && x.MA == bAn.KETQUA).FirstOrDefault();
                if (KQPT != null)
                {
                    PTBanAn.KETQUAPHUCTHAMID = KQPT.ID;
                    DM_KETQUA_PHUCTHAM_LYDO LyDo = dt.DM_KETQUA_PHUCTHAM_LYDO.Where(x => x.KETQUAID == KQPT.ID && x.MA == bAn.LYDO).FirstOrDefault();
                    if (LyDo != null)
                    {
                        PTBanAn.LYDOBANANID = LyDo.ID;
                    }
                }
                if (IsNew)
                {
                    // an hn
                    if (PTBanAn.TOA_GIAIQUYET_ID == null) 
                        PTBanAn.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    
                    dt.AHN_PHUCTHAM_BANAN.Add(PTBanAn);
                }
                dt.SaveChanges();
            }
        }
        private void UpdateKhangCao(List<KHANG_CAO> ListKhangCao, decimal ToaAnID, decimal DonID)
        {
            if (ListKhangCao.Count > 0)
            {
                bool IsNew = false;
                foreach (KHANG_CAO item in ListKhangCao)
                {
                    #region Lưu Nội dung kháng cáo
                    byte[] Guid_NguoiKC = item.GUID;
                    decimal NguoiKCID = 0;
                    AHN_DON_DUONGSU DuongSu = dt.AHN_DON_DUONGSU.Where(x => x.DONID == DonID && x.ID_DUONGSU_TACC == Guid_NguoiKC).FirstOrDefault();
                    if (DuongSu != null)
                    {
                        NguoiKCID = DuongSu.ID;
                    }
                    AHN_SOTHAM_KHANGCAO kc = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == DonID && x.DUONGSUID == NguoiKCID && x.TOAANRAQDID == ToaAnID).FirstOrDefault();
                    if (kc != null)
                    {
                        IsNew = true;
                        kc = new AHN_SOTHAM_KHANGCAO();
                        kc.NGAYTAO = DateTime.Now;
                    }
                    else
                    {
                        kc.NGAYSUA = DateTime.Now;
                    }
                    kc.DONID = DonID;
                    kc.TOAANRAQDID = ToaAnID;
                    kc.DUONGSUID = NguoiKCID;
                    DateTime NgayKhangCao = DateTime.MinValue;
                    if (DateTime.TryParseExact(item.NGAYKHANGCAO, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayKhangCao))
                    {
                        kc.NGAYKHANGCAO = NgayKhangCao;
                    }
                    kc.NOIDUNGKHANGCAO = item.NOIDUNGKHANGCAO;
                    if (IsNew)
                    {
                        if (kc.TOA_GIAIQUYET_ID == null)
                            kc.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        
                        dt.AHN_SOTHAM_KHANGCAO.Add(kc);
                    }
                    dt.SaveChanges();
                    #endregion
                }
            }
        }
        #endregion
        protected void cmdHuyNhan_Click(object sender, EventArgs e)
        {
            try
            {


                List<decimal> lstDonID = new List<decimal>();
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        var DonID = Convert.ToDecimal(chkChon.ToolTip);
                        lstDonID.Add(DonID);
                        //break;
                    }
                }

                //decimal ChuyenNhanID = 0;
                //foreach (DataGridItem Item in dgList.Items)
                //{
                //    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                //    if (chkChon.Checked)
                //    {
                //        ChuyenNhanID = Convert.ToDecimal(chkChon.ToolTip);
                //        break;
                //    }
                //}
                HuyNhan(lstDonID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ChuyenNhanID = Convert.ToDecimal(e.CommandArgument.ToString());

                List<decimal> lstDonID = new List<decimal>();
                lstDonID.Add(ChuyenNhanID);
                switch (e.CommandName)
                {
                    case "HuyNhan":
                        HuyNhan(lstDonID);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lbtHuyNhan = (LinkButton)e.Item.FindControl("lbtHuyNhan");
                if (rdbTrangthai.SelectedValue == "1")
                    lbtHuyNhan.Visible = true;
                else
                    lbtHuyNhan.Visible = false;
            }
        }
        private decimal Action_ChuyenAn_KhongThuoc_ThamQuyen(decimal DonID, string LoaiVuViec, decimal ToaNhanID, string MaToaNhan, string NguoiTao)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("IN_DONID",DonID),
                new OracleParameter("IN_LOAIVUVIEC",LoaiVuViec),
                new OracleParameter("IN_TOAANNHAN",ToaNhanID),
                new OracleParameter("IN_MA_TOA_NHAN",MaToaNhan),
                new OracleParameter("IN_NGUOITAO",NguoiTao),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_CVA_KHONG_THAM_QUYEN", parameters);
            decimal Result = 0;
            if (tbl.Rows.Count > 0)
                Result = Convert.ToDecimal(tbl.Rows[0]["ID"]);
            return Result;
        }
        private void HuyNhan(List<decimal> lstDonID)
        {
            AHN_DON_BL Bl = new AHN_DON_BL();
            //for (int i = 0; i < lstDonID.Count; i++)
            //{
            //    var ChuyenNhanID = lstDonID[i];
            //    decimal DonID_New = 0;
            //    AHN_CHUYEN_NHAN_AN ObjChuyenAn = dt.AHN_CHUYEN_NHAN_AN.Where(x => x.ID == ChuyenNhanID).FirstOrDefault();
            //    if (ObjChuyenAn != null)
            //    {
            //        DonID_New = ObjChuyenAn.MAP_VUANID_NEW + "" == "" ? 0 : (decimal)ObjChuyenAn.MAP_VUANID_NEW;
            //    }

            //    bool IsThuLy = Bl.Check_ThuLy(DonID_New);
            //    if (IsThuLy)
            //    {
            //        lbthongbao.Text = "Án đã được thụ lý. Không được phép hủy nhận án.";
            //        return;
            //    }
            //}


            for (int i = 0; i < lstDonID.Count; i++)
            {
                var ChuyenNhanID = lstDonID[i];
                decimal DonID_New = 0;
                AHN_CHUYEN_NHAN_AN ObjNhanAn = dt.AHN_CHUYEN_NHAN_AN.Where(x => x.ID == ChuyenNhanID).FirstOrDefault();
                if (ObjNhanAn != null)
                {
                    int LoaiVuViec = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH);
                    if (ObjNhanAn.MAP_VUANID_NEW.GetValueOrDefault(0) > 0)
                    {
                        DonID_New = ObjNhanAn.MAP_VUANID_NEW.Value;
                        bool IsThuLy = false;
                        if (rdbLoai.SelectedValue == "0")
                        {
                            AHN_DON_THAMPHAN thamPhan = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == DonID_New && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).FirstOrDefault();
                            if (thamPhan != null)
                            {
                                IsThuLy = true;
                                lbthongbao.Text = "Án đã được xử lý. Không được phép hủy nhận án.";
                                return;
                            }
                        }
                        else
                        {
                            IsThuLy = Bl.Check_ThuLy(DonID_New);
                            if (IsThuLy)
                            {
                                lbthongbao.Text = "Án đã được thụ lý. Không được phép hủy nhận án.";
                            }
                        }
                        if (!IsThuLy)
                        {
                            if (ObjNhanAn != null)
                            {
                                ObjNhanAn.MAP_VUANID_NEW = null;
                                ObjNhanAn.NGUOITAO_PHUCTHAM = null;
                                ObjNhanAn.NGAYTAO_PHUCTHAM = null;
                                ObjNhanAn.TRANGTHAI = 0;
                                ObjNhanAn.NGAYNHAN = null;
                                dt.SaveChanges();
                            }
                            //Luu thong tin ho so vu an khi xoa khi hủy nhận án
                            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            AHN_DON oDonNew = dt.AHN_DON.Where(x => x.ID == DonID_New).FirstOrDefault();
                            var json = new JavaScriptSerializer().Serialize(oDonNew);
                            ADS_DON_BL oBL = new ADS_DON_BL();
                            if (oBL.HISTORY_ALLDATA_BY_VUANID(DonID_New,Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH), Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Huỷ nhận án hành chính", "Xóa", json) == false)
                            {
                                break;
                            }
                            //Ket thuc 
                            Bl.DELETE_ALLDATA_BY_VUANID(DonID_New.ToString());
                            GIAI_DOAN_BL gdbl = new GIAI_DOAN_BL();
                            AHN_DON oVuan = dt.AHN_DON.Where(x => x.ID == ObjNhanAn.VUANID).FirstOrDefault();
                            gdbl.GIAIDOAN_DELETES(LoaiVuViec.ToString(), DonID_New, Convert.ToDecimal(oVuan.MAGIAIDOAN));
                            if (oDonNew.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                                oVuan.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            dt.SaveChanges();
                        }
                        else
                        {

                            return;
                        }
                    }
                    else
                    {
                        AHN_DON oVuan = dt.AHN_DON.Where(x => x.ID == ObjNhanAn.VUANID).FirstOrDefault();
                        if (oVuan.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                        {
                            AHN_CHUYEN_NHAN_AN_BL _chuyenNhanAnBl = new AHN_CHUYEN_NHAN_AN_BL();
                            var oldVuAnId = _chuyenNhanAnBl.getDonIdOld(oVuan.ID);
                            //lay chuyen an tu st len pt tdc
                            AHN_CHUYEN_NHAN_AN chuyenAnSTlenPTTDC = dt.AHN_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == oVuan.ID).FirstOrDefault();
                            List<AHN_SOTHAM_THULY> oThuLyST = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<AHN_SOTHAM_HDXX> oSTNguoiTienHanhToTung = dt.AHN_SOTHAM_HDXX.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<AHN_DON_THAMPHAN> oThamPhanST = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<AHN_SOTHAM_BANAN> oBanAnST = dt.AHN_SOTHAM_BANAN.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<AHN_SOTHAM_QUYETDINH> oQDST = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<AHN_SOTHAM_KHANGCAO> oKCST = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<AHN_SOTHAM_KHANGNGHI> oKNST = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();

                            if ((oThuLyST != null && oThuLyST.Count > 0) ||
                                (oSTNguoiTienHanhToTung != null && oSTNguoiTienHanhToTung.Count > 0) ||
                                (oThamPhanST != null && oThamPhanST.Count > 0) ||
                                (oBanAnST != null && oBanAnST.Count > 0) ||
                                (oQDST != null && oQDST.Count > 0) ||
                                (oKCST != null && oKCST.Count > 0) ||
                                (oKNST != null && oKNST.Count > 0))
                            {
                                lbthongbao.Text = "Án đã được thay đổi sau khi nhận. Không được phép hủy nhận án.";
                                return;
                            }
                            else
                            {
                                AHN_DON oVuAnOld = dt.AHN_DON.Where(x => x.ID == oldVuAnId).FirstOrDefault();
                                AHN_CHUYEN_NHAN_AN ObjNhanAnLanCuoi = dt.AHN_CHUYEN_NHAN_AN.Where(x => x.VUANID == oldVuAnId && x.TOACHUYENID == oVuAnOld.TOAANID).OrderByDescending(x => x.ID).FirstOrDefault();
                                AHN_CHUYEN_NHAN_AN ObjNhanAnLanGanCuoi = dt.AHN_CHUYEN_NHAN_AN.Where(x => x.VUANID == oldVuAnId && x.TOACHUYENID == oVuAnOld.TOAANID && x.ID < ObjNhanAnLanCuoi.ID).OrderByDescending(x => x.ID).FirstOrDefault();
                                if (ObjNhanAnLanGanCuoi == null)
                                {
                                    #region toancau - anhnt update lại kết quả kháng cáo/kháng nghị
                                    List<AHN_SOTHAM_KHANGCAO> khangCaos = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == oldVuAnId && x.TINHTRANG_GIAIQUYET == 1 && x.LOAIKHANGCAO == 2).ToList();
                                    if (khangCaos != null && khangCaos.Count > 0)
                                    {
                                        foreach (AHN_SOTHAM_KHANGCAO kc in khangCaos)
                                        {
                                            kc.TINHTRANG_GIAIQUYET = 0;
                                            dt.SaveChanges();
                                        }
                                    }
                                    List<AHN_SOTHAM_KHANGNGHI> khangNghis = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.DONID == oldVuAnId && x.TINHTRANG_GIAIQUYET == 1 && x.LOAIKN == 2).ToList();
                                    if (khangNghis != null && khangNghis.Count > 0)
                                    {
                                        foreach (AHN_SOTHAM_KHANGNGHI kn in khangNghis)
                                        {
                                            kn.TINHTRANG_GIAIQUYET = 0;
                                            dt.SaveChanges();
                                        }
                                    }
                                    #endregion toancau - tamnc update lại kết quả kháng cáo/kháng nghị
                                }
                                else
                                {
                                    #region toancau - anhnt update lại kết quả kháng cáo/kháng nghị
                                    List<AHN_SOTHAM_KHANGCAO> khangCaos = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == oldVuAnId && x.TINHTRANG_GIAIQUYET == 1 && x.LOAIKHANGCAO == 2 && x.NGAYTAO >= ObjNhanAnLanGanCuoi.NGAYTAO && x.NGAYTAO <= ObjNhanAnLanCuoi.NGAYTAO).ToList();
                                    if (khangCaos != null && khangCaos.Count > 0)
                                    {
                                        foreach (AHN_SOTHAM_KHANGCAO kc in khangCaos)
                                        {
                                            kc.TINHTRANG_GIAIQUYET = 0;
                                            dt.SaveChanges();
                                        }
                                    }
                                    List<AHN_SOTHAM_KHANGNGHI> khangNghis = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.DONID == oldVuAnId && x.TINHTRANG_GIAIQUYET == 1 && x.LOAIKN == 2 && x.NGAYTAO >= ObjNhanAnLanGanCuoi.NGAYTAO && x.NGAYTAO <= ObjNhanAnLanCuoi.NGAYTAO).ToList();
                                    if (khangNghis != null && khangNghis.Count > 0)
                                    {
                                        foreach (AHN_SOTHAM_KHANGNGHI kn in khangNghis)
                                        {
                                            kn.TINHTRANG_GIAIQUYET = 0;
                                            dt.SaveChanges();
                                        }
                                    }
                                    #endregion toancau - anhnt update lại kết quả kháng cáo/kháng nghị
                                }
                                ObjNhanAn.NGUOITAO_PHUCTHAM = null;
                                ObjNhanAn.NGAYTAO_PHUCTHAM = null;
                                ObjNhanAn.TRANGTHAI = 0;
                                ObjNhanAn.NGAYNHAN = null;

                                if (oVuAnOld != null)
                                    oVuAnOld.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                                dt.SaveChanges();
                            }
                        }
                        else
                        {
                            bool IsThuLy = Bl.Check_ThuLy(ObjNhanAn.VUANID.Value);
                            if (!IsThuLy)
                            {
                                ObjNhanAn.NGUOITAO_PHUCTHAM = null;
                                ObjNhanAn.NGAYTAO_PHUCTHAM = null;
                                ObjNhanAn.TRANGTHAI = 0;
                                dt.SaveChanges();
                                GIAI_DOAN_BL gdbl = new GIAI_DOAN_BL();
                                gdbl.GIAIDOAN_DELETES(LoaiVuViec.ToString(), Convert.ToDecimal(ObjNhanAn.VUANID), Convert.ToDecimal(oVuan.MAGIAIDOAN));
                            }
                            else
                            {
                                lbthongbao.Text = "Án đã được thụ lý. Không được phép hủy nhận án.";
                                return;
                            }
                        }

                    }
                }
            }


            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            lbthongbao.Text = "Hủy nhận án thành công.";
        }


        protected void rptCapNhat_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            DropDownList ddlN_Nguoinhan = e.Item.FindControl("ddlN_Nguoinhan") as DropDownList;

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ddlN_Nguoinhan.Items.Clear();
                //set lại dropdowlist


                //List<string> arr = new List<string>(); 
                DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
                DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                ddlN_Nguoinhan.DataSource = oCBDT;
                ddlN_Nguoinhan.DataTextField = "MA_TEN";
                ddlN_Nguoinhan.DataValueField = "ID";
                ddlN_Nguoinhan.DataBind();

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

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
    }
}
