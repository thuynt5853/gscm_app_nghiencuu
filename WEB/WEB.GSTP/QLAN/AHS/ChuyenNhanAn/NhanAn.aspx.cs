using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.AHS;
using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using NLog;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using WEB.GSTP.Models;

namespace WEB.GSTP.QLAN.AHS.ChuyenNhanAn
{
    public partial class NhanAn : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal DA_CHUYEN = 0, DA_NHAN = 1;
        private const string CONNECTION_TO_DB_TRUNGGIAN = "DB_TRUNG_GIAN_Connection";
        private decimal UserID = 0;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                UserID = Session[ENUM_SESSION.SESSION_USERID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                if (!IsPostBack)
                {
                    // Tạm thời COMMENT Chờ kết nối

                    #region Quét các vụ việc được chuyển từ Tòa án cấp cao và lưu vào AHS_DON và AHS_CHUYEN_NHAN_AN

                    //decimal ToaAnID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
                    //// Tòa án cấp cao: TRANG_THAI=1: Đã chuyển; TRANG_THAI=2: Đã nhận
                    //string sql = "select * from HOSO where TOA_AN_XET_XU='" + ToaAnID.ToString() + "' and LOAI_AN='" + ENUM_LOAIAN.AN_HINHSU + "' and TRANG_THAI=1";
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
                    //        #region Update Vụ việc AHS_DON
                    //        AHS_DON vDON = dt.AHS_DON.Where(x => x.MAVUVIEC == MaVuViec && ((x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && x.TOAANID == ToaAnID) || (x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && x.TOAPHUCTHAMID == ToaAnID))).FirstOrDefault();
                    //        if (vDON == null)
                    //        {
                    //            IsNew = true;
                    //            vDON = new AHS_DON();
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
                    //            dt.AHS_DON.Add(vDON);
                    //        }
                    //        dt.SaveChanges();
                    //        VuAnID = vDON.ID;
                    //        #endregion
                    //        #region Update Table AHS_CHUYEN_NHAN_AN
                    //        IsNew = false;
                    //        AHS_CHUYEN_NHAN_AN chuyen_nhan_an = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID && x.TOACHUYENID == Toa_Chuyen_ID && x.TOANHANID == Toa_Nhan_ID).FirstOrDefault();
                    //        if (chuyen_nhan_an == null)
                    //        {
                    //            IsNew = true;
                    //            chuyen_nhan_an = new AHS_CHUYEN_NHAN_AN();
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
                    //            dt.AHS_CHUYEN_NHAN_AN.Add(chuyen_nhan_an);
                    //        }
                    //        dt.SaveChanges();
                    //        #endregion
                    //    }
                    //}

                    #endregion Quét các vụ việc được chuyển từ Tòa án cấp cao và lưu vào AHS_DON và AHS_CHUYEN_NHAN_AN

                    LoadTHGiaoNhan();

                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    Cls_Comon.SetButton(cmdNhanan, false);
                    Cls_Comon.SetButton(cmdHuyNhan, false);
                }
            }
            catch (Exception ex) { 
                lbthongbao.Text = ex.Message; 
                // ghi log loi
                logger.Error("loi xay ra: " + ex);
            }
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
            DataTable oDT = oBL.HS_NHANAN(txt_NG_KC.Text.Trim(), txtSoQD.Text.Trim(), txt_NgayQD.Text.Trim(), vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, txtTenToa.Text, Convert.ToDecimal(ddlTHGN.SelectedValue), dFrom, dTo, Convert.ToDecimal(rdbTrangthai.SelectedValue));

            #region "Xác định số lượng trang"

            int Total = Convert.ToInt32(oDT.Rows.Count);
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

            #endregion "Xác định số lượng trang"

            dgList.DataSource = oDT;
            dgList.DataBind();
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

        #endregion "Phân trang"

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
            Cls_Comon.SetButton(cmdNhanan, true);
            Cls_Comon.SetButton(cmdHuyNhan, true);
            if (rdbTrangthai.SelectedValue == "1")
            {
                Cls_Comon.SetButton(cmdNhanan, false);
                Cls_Comon.SetButton(cmdHuyNhan, true);
            }
            else
            {
                Cls_Comon.SetButton(cmdNhanan, true);
                Cls_Comon.SetButton(cmdHuyNhan, false);
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

                decimal ChuyenNhanAnID = Convert.ToDecimal(hddChuyenNhanAnID.Value);
                AHS_CHUYEN_NHAN_AN oT = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.ID == ChuyenNhanAnID).FirstOrDefault();
                if (oT != null)
                {
                    decimal VuAnID = (decimal)oT.VUANID;

                    //Cập nhật lại thông tin án
                    AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.ID == oT.TRUONGHOPGIAONHANID).FirstOrDefault();
                    if (oIT.MA == ENUM_TRUONGHOP_GIAONHAN.KHONGTHUOC_THAMQUYEN_XETXU)
                    {
                        if (oVuAn.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM)
                        {
                            oVuAn.TOAAN_CHUYEN_ID = oVuAn.TOAPHUCTHAMID;
                            oVuAn.TOAPHUCTHAMID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            //anhvh add 26/06/2020
                            //GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            //GD.GAIDOAN_INSERT_UPDATE("1", VuAnID, 3, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
                        }
                        else
                        {
                            /*  Lê Nam
                                Chuyển án không thuộc thẩm quyền
                            */
                            string UserName = Session[ENUM_SESSION.SESSION_USERNAME] + "", LoaiVuAn = ENUM_LOAIVUVIEC.AN_HINHSU, MaToaAn = Session[ENUM_SESSION.SESSION_MADONVI] + "";
                            decimal ToaAnNhan = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
                                    VuAnID_New = Action_ChuyenAn_KhongThuoc_ThamQuyen(VuAnID, LoaiVuAn, ToaAnNhan, MaToaAn, UserName);

                            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            GD.GAIDOAN_INSERT_UPDATE("1", VuAnID_New, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                        }
                    }
                    else if (oIT.MA == ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM)
                    {
                        if (oVuAn.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                        {
                            //oDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            //dt.SaveChanges();
                            AHS_CHUYEN_NHAN_AN_BL _caBL = new AHS_CHUYEN_NHAN_AN_BL();
                            decimal donIdOld = _caBL.getDonIdOld(oVuAn.ID);
                            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            AHS_VUAN oDonOld = dt.AHS_VUAN.Where(x => x.ID == donIdOld).FirstOrDefault();
                            oDonOld.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            dt.SaveChanges();
                            GD.GAIDOAN_INSERT_UPDATE("1", donIdOld, ENUM_GIAIDOANVUAN.SOTHAM, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);

                            #region toancau - anhnt update lại kết quả kháng cáo/kháng nghị

                            List<AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST> listKCKN = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST>($"VUANPT_ID ={oVuAn.ID}");
                            List<decimal> lstKCST = listKCKN.Where(x => x.IS_KC == 1).Select(x => x.KCKN_SOTHAM_ID.Value).ToList();

                            List<AHS_SOTHAM_KHANGCAO> khangCaos = dt.AHS_SOTHAM_KHANGCAO.Where(x => lstKCST.Contains(x.ID)).ToList();
                            if (khangCaos != null && khangCaos.Count > 0)
                            {
                                foreach (AHS_SOTHAM_KHANGCAO kc in khangCaos)
                                {
                                    kc.TINHTRANG_GIAIQUYET = 1;
                                    dt.SaveChanges();
                                }
                            }

                            List<decimal> lstKNST = listKCKN.Where(x => x.IS_KC.GetValueOrDefault(0) == 0).Select(x => x.KCKN_SOTHAM_ID.Value).ToList();
                            List<AHS_SOTHAM_KHANGNGHI> khangNghis = dt.AHS_SOTHAM_KHANGNGHI.Where(x => lstKNST.Contains(x.ID)).ToList();
                            if (khangNghis != null && khangNghis.Count > 0)
                            {
                                foreach (AHS_SOTHAM_KHANGNGHI kn in khangNghis)
                                {
                                    kn.TINHTRANG_GIAIQUYET = 1;
                                    dt.SaveChanges();
                                }
                            }

                            #endregion toancau - anhnt update lại kết quả kháng cáo/kháng nghị
                        }
                        else
                        {
                            //oVuAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            //dt.SaveChanges();
                            ////anhvh add 26/06/2020
                            //GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            //GD.GAIDOAN_INSERT_UPDATE("1", VuAnID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                            //manhnd add 07/12/2021
                            //Neu do Phuc tham chuyen ve de xet xu lai thi phải tao vụ án mới từ Vu an da co
                            AHS_VUAN oVUAN_new = new AHS_VUAN();

                            oVUAN_new.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            oVUAN_new.VKSID = oVuAn.VKSID;
                            oVUAN_new.TRUONGHOPGIAONHAN = oT.TRUONGHOPGIAONHANID;
                            oVUAN_new.SOBANCAOTRANG = oVuAn.SOBANCAOTRANG;
                            oVUAN_new.NGAYBANCAOTRANG = oVuAn.NGAYBANCAOTRANG;
                            oVUAN_new.SOBUTLUC = oVuAn.SOBUTLUC;
                            oVUAN_new.NGAYGIAO = oVuAn.NGAYGIAO;
                            oVUAN_new.QUYETDINHTRUYTO = oVuAn.QUYETDINHTRUYTO;

                            oVUAN_new.TENVUAN = oVuAn.TENVUAN;
                            oVUAN_new.TENKHAC = oVuAn.TENKHAC;
                            oVUAN_new.SOBICAN = oVuAn.SOBICAN;
                            oVUAN_new.SOBICANTAMGIAM = oVuAn.SOBICANTAMGIAM;
                            oVUAN_new.LOAITOIPHAMID = oVuAn.LOAITOIPHAMID;
                            oVUAN_new.NGAYXAYRA = oVuAn.NGAYXAYRA;
                            oVUAN_new.THANGXAYRA = oVuAn.THANGXAYRA;
                            oVUAN_new.NAMXAYRA = oVuAn.NAMXAYRA;
                            oVUAN_new.GIOXAYRA = oVuAn.GIOXAYRA;
                            oVUAN_new.GHICHU = oVuAn.GHICHU;
                            oVUAN_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            oVUAN_new.NGAYTAO = DateTime.Now;
                            AHS_VUAN_BL dsBL = new AHS_VUAN_BL();
                            oVUAN_new.TT = dsBL.GETNEWTT((decimal)oVUAN_new.TOAANID);
                            //oVUAN_new.MAVUAN = ENUM_LOAIVUVIEC.AN_HINHSU + Session[ENUM_SESSION.SESSION_MADONVI] + oVUAN_new.TT.ToString();
                            oVUAN_new.MAVUAN = oVuAn.MAVUAN;
                            oVUAN_new.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            oVUAN_new.TOAPHUCTHAMID = oVuAn.TOAPHUCTHAMID;
                            oVUAN_new.ID_HO_SO_FROM_TOA_CAP_CAO = oVuAn.ID_HO_SO_FROM_TOA_CAP_CAO;
                            oVUAN_new.TOAAN_CHUYEN_ID = oVuAn.TOAAN_CHUYEN_ID;
                            // update insert toa_phuctham_gq_id
                            oVUAN_new.TOA_PHUCTHAM_GIAIQUYET_ID = oVuAn.TOA_PHUCTHAM_GIAIQUYET_ID;

                            // insert toa_gq_id
                            oVUAN_new.TOA_GIAIQUYET_ID = oVuAn.TOA_GIAIQUYET_ID;
                            dt.AHS_VUAN.Add(oVUAN_new);
                            dt.SaveChanges();

                            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            GD.GAIDOAN_INSERT_UPDATE("1", oVUAN_new.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                            //Nhan ban Bị cao theo Vụ an moi
                            List<AHS_BICANBICAO> lst = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).ToList<AHS_BICANBICAO>();
                            foreach (AHS_BICANBICAO vbicao in lst)
                            {
                                AHS_BICANBICAO oBiCao_new = new AHS_BICANBICAO();
                                oBiCao_new.VUANID = oVUAN_new.ID;
                                oBiCao_new.MABICAN = vbicao.MABICAN;
                                oBiCao_new.BICANDAUVU = vbicao.BICANDAUVU;
                                oBiCao_new.HOTEN = vbicao.HOTEN;
                                oBiCao_new.TENKHAC = vbicao.TENKHAC;
                                oBiCao_new.NGAYSINH = vbicao.NGAYSINH;
                                oBiCao_new.THANGSINH = vbicao.THANGSINH;
                                oBiCao_new.NAMSINH = vbicao.NAMSINH;
                                oBiCao_new.NGAYTHAMGIA = vbicao.NGAYTHAMGIA;
                                oBiCao_new.SOCMND = vbicao.SOCMND;
                                oBiCao_new.TAMTRU = vbicao.TAMTRU;
                                oBiCao_new.TAMTRUCHITIET = vbicao.TAMTRUCHITIET;
                                oBiCao_new.HKTT = vbicao.HKTT;
                                oBiCao_new.KHTTCHITIET = vbicao.KHTTCHITIET;
                                oBiCao_new.TRINHDOVANHOAID = vbicao.TRINHDOVANHOAID;
                                oBiCao_new.NGHENGHIEPID = vbicao.NGHENGHIEPID;
                                oBiCao_new.DANTOCID = vbicao.DANTOCID;
                                oBiCao_new.QUOCTICHID = vbicao.QUOCTICHID;
                                oBiCao_new.GIOITINH = vbicao.GIOITINH;
                                oBiCao_new.TONGIAOID = vbicao.TONGIAOID;
                                oBiCao_new.NGHIENHUT = vbicao.NGHIENHUT;
                                oBiCao_new.TAIPHAM = vbicao.TAIPHAM;
                                oBiCao_new.TIENAN = vbicao.TIENAN;
                                oBiCao_new.TIENSU = vbicao.TIENSU;
                                oBiCao_new.TREMOCOI = vbicao.TREMOCOI;
                                oBiCao_new.BOMELYHON = vbicao.BOMELYHON;
                                oBiCao_new.TREBOHOC = vbicao.TREBOHOC;
                                oBiCao_new.TRELANGTHANG = vbicao.TRELANGTHANG;
                                oBiCao_new.CONGUOIXUIGIUC = vbicao.CONGUOIXUIGIUC;
                                oBiCao_new.CHUCVUDANGID = vbicao.CHUCVUDANGID;
                                oBiCao_new.CHUCVUCHINHQUYENID = vbicao.CHUCVUCHINHQUYENID;
                                oBiCao_new.TINHTRANGGIAMGIUID = vbicao.TINHTRANGGIAMGIUID;
                                oBiCao_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oBiCao_new.NGAYTAO = DateTime.Now;
                                oBiCao_new.ISTREVITHANHNIEN = vbicao.ISTREVITHANHNIEN;
                                oBiCao_new.LOAIDOITUONG = vbicao.LOAIDOITUONG;
                                oBiCao_new.HKTT_HUYEN = vbicao.HKTT_HUYEN;
                                oBiCao_new.TAMTRU_HUYEN = vbicao.TAMTRU_HUYEN;
                                oBiCao_new.TAIPHAMNGUYHIEM = vbicao.TAIPHAMNGUYHIEM;
                                oBiCao_new.TUOI = vbicao.TUOI;
                                oBiCao_new.DIACHICOQUAN = vbicao.DIACHICOQUAN;
                                oBiCao_new.LOAITOIPHAMHS_ID = vbicao.LOAITOIPHAMHS_ID;
                                oBiCao_new.BICANBICAOID_TACC = vbicao.BICANBICAOID_TACC;
                                oBiCao_new.TOA_GIAIQUYET_ID = oVuAn.TOA_GIAIQUYET_ID;
                                // vnpt 06/12/2025
                                oBiCao_new.XACTHUC_DLDCQG = vbicao.XACTHUC_DLDCQG;
                                dt.AHS_BICANBICAO.Add(oBiCao_new);
                                dt.SaveChanges();
                                //Cập nhật điều luật áp dụng
                                List<AHS_SOTHAM_CAOTRANG_DIEULUAT> List_DieuLuat_OLD = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID && x.BICANID == vbicao.ID).ToList<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
                                foreach (AHS_SOTHAM_CAOTRANG_DIEULUAT vDieuLuat_OLD in List_DieuLuat_OLD)
                                {
                                    AHS_SOTHAM_CAOTRANG_DIEULUAT vDieuLuat = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
                                    vDieuLuat.BICANID = oBiCao_new.ID;
                                    vDieuLuat.CAOTRANGID = vDieuLuat_OLD.CAOTRANGID;
                                    vDieuLuat.DIEULUATID = vDieuLuat_OLD.DIEULUATID;
                                    vDieuLuat.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    vDieuLuat.NGAYTAO = DateTime.Now;
                                    vDieuLuat.TOIDANHID = vDieuLuat_OLD.TOIDANHID;
                                    vDieuLuat.VUANID = oVUAN_new.ID;
                                    vDieuLuat.TENTOIDANH = vDieuLuat_OLD.TENTOIDANH;
                                    vDieuLuat.ISMAIN = vDieuLuat_OLD.ISMAIN;
                                    vDieuLuat.TOA_GIAIQUYET_ID = vDieuLuat_OLD.TOA_GIAIQUYET_ID;
                                    dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Add(vDieuLuat);
                                    dt.SaveChanges();
                                }
                                //Bien phap ngan chan
                                List<AHS_SOTHAM_BIENPHAPNGANCHAN> List_BienPhap = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.VUANID == VuAnID && x.BICANID == vbicao.ID).ToList<AHS_SOTHAM_BIENPHAPNGANCHAN>();
                                foreach (AHS_SOTHAM_BIENPHAPNGANCHAN vBienPhap_OLD in List_BienPhap)
                                {
                                    AHS_SOTHAM_BIENPHAPNGANCHAN vBienPhap_new = new AHS_SOTHAM_BIENPHAPNGANCHAN();
                                    vBienPhap_new.BICANID = oBiCao_new.ID;
                                    vBienPhap_new.DONVIRAQD = vBienPhap_OLD.DONVIRAQD;
                                    vBienPhap_new.BIENPHAPNGANCHANID = vBienPhap_OLD.BIENPHAPNGANCHANID;
                                    vBienPhap_new.HIEULUC = vBienPhap_OLD.HIEULUC;
                                    vBienPhap_new.NGAYBATDAU = vBienPhap_OLD.NGAYBATDAU;
                                    vBienPhap_new.NGAYKETTHUC = vBienPhap_OLD.NGAYKETTHUC;
                                    vBienPhap_new.GHICHU = vBienPhap_OLD.GHICHU;
                                    vBienPhap_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    vBienPhap_new.NGAYTAO = DateTime.Now;
                                    vBienPhap_new.VUANID = oVUAN_new.ID;
                                    vBienPhap_new.FILEID = vBienPhap_OLD.FILEID;
                                    vBienPhap_new.TENFILE = vBienPhap_OLD.TENFILE;
                                    vBienPhap_new.SOQD = vBienPhap_OLD.SOQD;
                                    vBienPhap_new.NGAYQD = vBienPhap_OLD.NGAYQD;
                                    vBienPhap_new.KIEUFILE = vBienPhap_OLD.KIEUFILE;
                                    vBienPhap_new.NOIDUNGFILE = vBienPhap_OLD.NOIDUNGFILE;
                                    vBienPhap_new.GIAIDOANAPDUNG = vBienPhap_OLD.GIAIDOANAPDUNG;
                                    vBienPhap_new.NOIGIAMGIU = vBienPhap_OLD.NOIGIAMGIU;
                                    vBienPhap_new.TOA_GIAIQUYET_ID = vBienPhap_OLD.TOA_GIAIQUYET_ID;
                                    dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Add(vBienPhap_new);
                                    dt.SaveChanges();
                                }
                            }
                            //Bi hai
                            List<AHS_NGUOITHAMGIATOTUNG> List_Bihai = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID).ToList<AHS_NGUOITHAMGIATOTUNG>();
                            foreach (AHS_NGUOITHAMGIATOTUNG vBiHai_OLD in List_Bihai)
                            {
                                AHS_NGUOITHAMGIATOTUNG_TUCACH obj = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == vBiHai_OLD.ID && x.TUCACHID == 122).FirstOrDefault<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
                                if (obj != null)
                                {
                                    AHS_NGUOITHAMGIATOTUNG vBiHai_new = new AHS_NGUOITHAMGIATOTUNG();
                                    vBiHai_new.VUANID = oVUAN_new.ID;
                                    vBiHai_new.HOTEN = vBiHai_OLD.HOTEN;
                                    vBiHai_new.DIACHIID = vBiHai_OLD.DIACHIID;
                                    vBiHai_new.DIACHICHITIET = vBiHai_OLD.DIACHICHITIET;
                                    vBiHai_new.GIOITINH = vBiHai_OLD.GIOITINH;
                                    vBiHai_new.NGAYSINH = vBiHai_OLD.NGAYSINH;
                                    vBiHai_new.THANGSINH = vBiHai_OLD.THANGSINH;
                                    vBiHai_new.NAMSINH = vBiHai_OLD.NAMSINH;
                                    vBiHai_new.NGHENGHIEPID = vBiHai_OLD.NGHENGHIEPID;
                                    vBiHai_new.CHUCVU = vBiHai_OLD.CHUCVU;
                                    vBiHai_new.NGAYTHAMGIA = vBiHai_OLD.NGAYTHAMGIA;
                                    vBiHai_new.NGAYKETTHUC = vBiHai_OLD.NGAYKETTHUC;
                                    vBiHai_new.GHICHU = vBiHai_OLD.GHICHU;
                                    vBiHai_new.ISHOSO = vBiHai_OLD.ISHOSO;
                                    vBiHai_new.ISSOTHAM = vBiHai_OLD.ISSOTHAM;
                                    vBiHai_new.ISPHUCTHAM = vBiHai_OLD.ISPHUCTHAM;
                                    vBiHai_new.ISTREVITHANHNIEN = vBiHai_OLD.ISTREVITHANHNIEN;
                                    vBiHai_new.LOAITREVITHANHNIEN = vBiHai_OLD.LOAITREVITHANHNIEN;
                                    vBiHai_new.LOAIDT = vBiHai_OLD.LOAIDT;
                                    vBiHai_new.NDD_HOTEN = vBiHai_OLD.NDD_HOTEN;
                                    vBiHai_new.NDD_CHUCVU = vBiHai_OLD.NDD_CHUCVU;
                                    vBiHai_new.NDD_CMND = vBiHai_OLD.NDD_CMND;
                                    vBiHai_new.NDD_MOBILE = vBiHai_OLD.NDD_MOBILE;
                                    vBiHai_new.NDD_EMAIL = vBiHai_OLD.NDD_EMAIL;
                                    vBiHai_new.FILEID = vBiHai_OLD.FILEID;
                                    vBiHai_new.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    vBiHai_new.NGAYSUA = DateTime.Now;
                                    vBiHai_new.ID_NGUOITGTT_QLTACC = vBiHai_OLD.ID_NGUOITGTT_QLTACC;
                                    vBiHai_new.TOA_GIAIQUYET_ID = vBiHai_OLD.TOA_GIAIQUYET_ID;
                                    dt.AHS_NGUOITHAMGIATOTUNG.Add(vBiHai_new);
                                    dt.SaveChanges();

                                    AHS_NGUOITHAMGIATOTUNG_TUCACH vBihai_TuCach = new AHS_NGUOITHAMGIATOTUNG_TUCACH();
                                    vBihai_TuCach.NGUOIID = vBiHai_new.ID;
                                    vBihai_TuCach.TUCACHID = 122;
                                    dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Add(vBihai_TuCach);
                                    dt.SaveChanges();
                                }
                            }

                            oT.MAP_VUANID_NEW = oVUAN_new.ID;
                        }
                    }
                    else if (oIT.MA == ENUM_TRUONGHOP_GIAONHAN.TOA_CAPCAO_CHUYEN_VE)
                    {
                        byte[] bGuid = oVuAn.ID_HO_SO_FROM_TOA_CAP_CAO;
                        // Lưu thông tin liên quan vụ án vào các bảng dữ liệu tương ứng
                        string sql = "select * from HOSO where Guid='" + bGuid + "'";
                        DataTable tblHoSo = Cls_Comon.GetTableToSQL(CONNECTION_TO_DB_TRUNGGIAN, sql);
                        if (tblHoSo.Rows.Count > 0)
                        {
                            DataRow r = tblHoSo.Rows[0];
                            string LoaiAn = r["LOAI_AN"].ToString(),
                                   CapXetXu = r["CAP_XET_XU"].ToString();
                            if (LoaiAn == ENUM_LOAIAN.AN_HINHSU)
                            {
                                #region Update bị cáo, tội danh, hình phạt

                                string strList_BiCao_ToiDanh = JsonConvert.SerializeObject(r["NGUOI_THAM_GIA_AHS"].ToString());
                                List<NGUOI_THAM_GIA_AHS> List_BiCao_ToiDanh = JsonConvert.DeserializeObject<List<NGUOI_THAM_GIA_AHS>>(strList_BiCao_ToiDanh);
                                UpdateBiCanBiCao(List_BiCao_ToiDanh, VuAnID);

                                #endregion Update bị cáo, tội danh, hình phạt

                                #region Update Người tham gia tố tụng

                                string strList_NguoiTGTT = JsonConvert.SerializeObject(r["NGUOI_THAM_GIA_CHUNG"].ToString());
                                List<NGUOI_THAM_GIA_CHUNG> List_NguoiTGTT = JsonConvert.DeserializeObject<List<NGUOI_THAM_GIA_CHUNG>>(strList_NguoiTGTT);
                                UpdateNguoiTGTT(List_NguoiTGTT, VuAnID);

                                #endregion Update Người tham gia tố tụng

                                #region Update Thụ lý

                                string strThuLy = JsonConvert.SerializeObject(r["THU_LY"].ToString());
                                THU_LY oTHU_LY = JsonConvert.DeserializeObject<THU_LY>(strThuLy);
                                UpdateThuLy(oTHU_LY, (decimal)oT.TOANHANID, VuAnID, CapXetXu);

                                #endregion Update Thụ lý

                                #region Update Danh sách người tiến hành tố tụng

                                string strList_NguoiTHTT = JsonConvert.SerializeObject(r["NGUOI_TIEN_HANH_TO_TUNG"].ToString());
                                List<NGUOI_TIEN_HANH_TO_TUNG> List_NguoiTHTT = JsonConvert.DeserializeObject<List<NGUOI_TIEN_HANH_TO_TUNG>>(strList_NguoiTHTT);
                                UpdateNguoiTHTT(List_NguoiTHTT, VuAnID, CapXetXu);

                                #endregion Update Danh sách người tiến hành tố tụng

                                #region Update Quyết định vụ án

                                string strList_QD = JsonConvert.SerializeObject(r["QUYET_DINH"].ToString());
                                List<QUYET_DINH> List_QD = JsonConvert.DeserializeObject<List<QUYET_DINH>>(strList_QD);
                                UpdateQDVuAn(List_QD, (decimal)oT.TOANHANID, VuAnID, CapXetXu);

                                #endregion Update Quyết định vụ án

                                #region Update Bản án

                                string strBanAn = JsonConvert.SerializeObject(r["BAN_AN"].ToString());
                                BAN_AN oBanAn = JsonConvert.DeserializeObject<BAN_AN>(strBanAn);
                                string LichXetXu = JsonConvert.SerializeObject(r["LICH_XET_XU"].ToString());
                                LICH_XET_XU oLichXetXu = JsonConvert.DeserializeObject<LICH_XET_XU>(LichXetXu);
                                UpdateBanAn(oBanAn, oLichXetXu, (decimal)oT.TOANHANID, VuAnID, CapXetXu);

                                #endregion Update Bản án

                                #region Update Kháng cáo

                                string strList_KhangCao = JsonConvert.SerializeObject(r["KHANG_CAO"].ToString());
                                List<KHANG_CAO> List_KhangCao = JsonConvert.DeserializeObject<List<KHANG_CAO>>(strList_KhangCao);
                                UpdateKhangCao(List_KhangCao, (decimal)oVuAn.TOAANID, VuAnID);

                                #endregion Update Kháng cáo
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
                        string UserName = Session[ENUM_SESSION.SESSION_USERNAME] + "", LoaiVuAn = ENUM_LOAIVUVIEC.AN_HINHSU, MaToaAn = Session[ENUM_SESSION.SESSION_MADONVI] + "";
                        decimal ToaAnNhan = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
                                VuAnID_New = Action_ChuyenAn_KhongThuoc_ThamQuyen(VuAnID, LoaiVuAn, ToaAnNhan, MaToaAn, UserName);

                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        GD.GAIDOAN_INSERT_UPDATE("1", VuAnID_New, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                    }
                    else
                    {
                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        oVuAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                        oVuAn.TOAPHUCTHAMID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.SaveChanges();
                        AHS_CHUYEN_NHAN_AN_BL chuyenNhanBl = new AHS_CHUYEN_NHAN_AN_BL();
                        if (chuyenNhanBl.CheckCoKcKnTamDinhChi(VuAnID))
                        {
                            #region toancau anhnt-nhận án có kháng cáo kháng nghị tạm đình chỉ

                            //check vụ án đang xử lý phúc thẩm tạm đình chỉ
                            AHS_KCKNQDK_PHUCTHAM_BL oBL = new AHS_KCKNQDK_PHUCTHAM_BL();
                            decimal idPTDangXuLyTDC = oBL.GetVuAnDangXuLyPTTDC(oVuAn.ID, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                            if (idPTDangXuLyTDC > 0)
                            {
                                List<AHS_CHUYEN_NHAN_AN_KCKN> listKCKN = DataExtensions.GetAllWithClause<AHS_CHUYEN_NHAN_AN_KCKN>($"CHUYENNHANID = {ChuyenNhanAnID}").ToList();
                                foreach (var mapkckn in listKCKN)
                                {
                                    AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST obnew = new AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST()
                                    {
                                        IS_KC = mapkckn.ISKC,
                                        KCKN_SOTHAM_ID = mapkckn.KCKNID,
                                        NGAY_TAO = DateTime.Now,
                                        NHANANID = ChuyenNhanAnID,
                                        TRANG_THAI_ID = 0,
                                        VUANPT_ID = idPTDangXuLyTDC,
                                        VUANST_ID = oVuAn.ID
                                    };
                                    DataExtensions.Insert(obnew);
                                }
                                oVuAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            }
                            else
                            {
                                #region tạo mới đơn trên phúc thẩm tđc

                                AHS_VUAN oVUAN_new = new AHS_VUAN();

                                oVUAN_new.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                oVUAN_new.VKSID = oVuAn.VKSID;
                                // vnpt HOANGNDH 11122025
                                // TH thụ lý xx lại ST thì nhận án PT TH giao nhận "Thụ lý mới"
                                if (oVuAn.TRUONGHOPGIAONHAN == Convert.ToDecimal(ENUM_TRUONGHOP_GIAONHAN.GDT_HUY_TRA_VE_ST))
                                {
                                    oVUAN_new.TRUONGHOPGIAONHAN = ENUM_GDTTT_TRANGTHAI.THULY_MOI;
                                }
                                oVUAN_new.SOBANCAOTRANG = oVuAn.SOBANCAOTRANG;
                                oVUAN_new.NGAYBANCAOTRANG = oVuAn.NGAYBANCAOTRANG;
                                oVUAN_new.SOBUTLUC = oVuAn.SOBUTLUC;
                                oVUAN_new.NGAYGIAO = oVuAn.NGAYGIAO;
                                oVUAN_new.QUYETDINHTRUYTO = oVuAn.QUYETDINHTRUYTO;

                                oVUAN_new.TENVUAN = oVuAn.TENVUAN;
                                oVUAN_new.TENKHAC = oVuAn.TENKHAC;
                                oVUAN_new.SOBICAN = oVuAn.SOBICAN;
                                oVUAN_new.SOBICANTAMGIAM = oVuAn.SOBICANTAMGIAM;
                                oVUAN_new.LOAITOIPHAMID = oVuAn.LOAITOIPHAMID;
                                oVUAN_new.NGAYXAYRA = oVuAn.NGAYXAYRA;
                                oVUAN_new.THANGXAYRA = oVuAn.THANGXAYRA;
                                oVUAN_new.NAMXAYRA = oVuAn.NAMXAYRA;
                                oVUAN_new.GIOXAYRA = oVuAn.GIOXAYRA;
                                oVUAN_new.GHICHU = oVuAn.GHICHU;
                                oVUAN_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oVUAN_new.NGAYTAO = DateTime.Now;
                                AHS_VUAN_BL dsBL = new AHS_VUAN_BL();
                                oVUAN_new.TT = dsBL.GETNEWTT((decimal)oVUAN_new.TOAANID);
                                //oVUAN_new.MAVUAN = ENUM_LOAIVUVIEC.AN_HINHSU + Session[ENUM_SESSION.SESSION_MADONVI] + oVUAN_new.TT.ToString();
                                oVUAN_new.MAVUAN = oVuAn.MAVUAN;
                                oVUAN_new.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM_QDK;
                                oVUAN_new.TOAPHUCTHAMID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                oVUAN_new.ID_HO_SO_FROM_TOA_CAP_CAO = oVuAn.ID_HO_SO_FROM_TOA_CAP_CAO;
                                oVUAN_new.TOAAN_CHUYEN_ID = oVuAn.TOAAN_CHUYEN_ID;
                                oVUAN_new.TOA_GIAIQUYET_ID = oVuAn.TOA_GIAIQUYET_ID;
                                // update insert toa_pt_gq_id
                                oVUAN_new.TOA_PHUCTHAM_GIAIQUYET_ID = oVuAn.TOA_PHUCTHAM_GIAIQUYET_ID;

                                dt.AHS_VUAN.Add(oVUAN_new);
                                dt.SaveChanges();

                                GD.GAIDOAN_INSERT_UPDATE("1", oVUAN_new.ID, ENUM_GIAIDOANVUAN.PHUCTHAM_QDK, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);

                                ////Nhan ban Bị cao theo Vụ an moi
                                //List<AHS_BICANBICAO> lst = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).ToList<AHS_BICANBICAO>();
                                //foreach (AHS_BICANBICAO vbicao in lst)
                                //{
                                //    AHS_BICANBICAO oBiCao_new = new AHS_BICANBICAO();
                                //    oBiCao_new.VUANID = oVUAN_new.ID;
                                //    oBiCao_new.MABICAN = vbicao.MABICAN;
                                //    oBiCao_new.BICANDAUVU = vbicao.BICANDAUVU;
                                //    oBiCao_new.HOTEN = vbicao.HOTEN;
                                //    oBiCao_new.TENKHAC = vbicao.TENKHAC;
                                //    oBiCao_new.NGAYSINH = vbicao.NGAYSINH;
                                //    oBiCao_new.THANGSINH = vbicao.THANGSINH;
                                //    oBiCao_new.NAMSINH = vbicao.NAMSINH;
                                //    oBiCao_new.NGAYTHAMGIA = vbicao.NGAYTHAMGIA;
                                //    oBiCao_new.SOCMND = vbicao.SOCMND;
                                //    oBiCao_new.TAMTRU = vbicao.TAMTRU;
                                //    oBiCao_new.TAMTRUCHITIET = vbicao.TAMTRUCHITIET;
                                //    oBiCao_new.HKTT = vbicao.HKTT;
                                //    oBiCao_new.KHTTCHITIET = vbicao.KHTTCHITIET;
                                //    oBiCao_new.TRINHDOVANHOAID = vbicao.TRINHDOVANHOAID;
                                //    oBiCao_new.NGHENGHIEPID = vbicao.NGHENGHIEPID;
                                //    oBiCao_new.DANTOCID = vbicao.DANTOCID;
                                //    oBiCao_new.QUOCTICHID = vbicao.QUOCTICHID;
                                //    oBiCao_new.GIOITINH = vbicao.GIOITINH;
                                //    oBiCao_new.TONGIAOID = vbicao.TONGIAOID;
                                //    oBiCao_new.NGHIENHUT = vbicao.NGHIENHUT;
                                //    oBiCao_new.TAIPHAM = vbicao.TAIPHAM;
                                //    oBiCao_new.TIENAN = vbicao.TIENAN;
                                //    oBiCao_new.TIENSU = vbicao.TIENSU;
                                //    oBiCao_new.TREMOCOI = vbicao.TREMOCOI;
                                //    oBiCao_new.BOMELYHON = vbicao.BOMELYHON;
                                //    oBiCao_new.TREBOHOC = vbicao.TREBOHOC;
                                //    oBiCao_new.TRELANGTHANG = vbicao.TRELANGTHANG;
                                //    oBiCao_new.CONGUOIXUIGIUC = vbicao.CONGUOIXUIGIUC;
                                //    oBiCao_new.CHUCVUDANGID = vbicao.CHUCVUDANGID;
                                //    oBiCao_new.CHUCVUCHINHQUYENID = vbicao.CHUCVUCHINHQUYENID;
                                //    oBiCao_new.TINHTRANGGIAMGIUID = vbicao.TINHTRANGGIAMGIUID;
                                //    oBiCao_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                //    oBiCao_new.NGAYTAO = DateTime.Now;
                                //    oBiCao_new.ISTREVITHANHNIEN = vbicao.ISTREVITHANHNIEN;
                                //    oBiCao_new.LOAIDOITUONG = vbicao.LOAIDOITUONG;
                                //    oBiCao_new.HKTT_HUYEN = vbicao.HKTT_HUYEN;
                                //    oBiCao_new.TAMTRU_HUYEN = vbicao.TAMTRU_HUYEN;
                                //    oBiCao_new.TAIPHAMNGUYHIEM = vbicao.TAIPHAMNGUYHIEM;
                                //    oBiCao_new.TUOI = vbicao.TUOI;
                                //    oBiCao_new.DIACHICOQUAN = vbicao.DIACHICOQUAN;
                                //    oBiCao_new.LOAITOIPHAMHS_ID = vbicao.LOAITOIPHAMHS_ID;
                                //    oBiCao_new.BICANBICAOID_TACC = vbicao.BICANBICAOID_TACC;
                                //    dt.AHS_BICANBICAO.Add(oBiCao_new);
                                //    dt.SaveChanges();
                                //    //Cập nhật điều luật áp dụng
                                //    List<AHS_SOTHAM_CAOTRANG_DIEULUAT> List_DieuLuat_OLD = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID && x.BICANID == vbicao.ID).ToList<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
                                //    foreach (AHS_SOTHAM_CAOTRANG_DIEULUAT vDieuLuat_OLD in List_DieuLuat_OLD)
                                //    {
                                //        AHS_SOTHAM_CAOTRANG_DIEULUAT vDieuLuat = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
                                //        vDieuLuat.BICANID = oBiCao_new.ID;
                                //        vDieuLuat.CAOTRANGID = vDieuLuat_OLD.CAOTRANGID;
                                //        vDieuLuat.DIEULUATID = vDieuLuat_OLD.DIEULUATID;
                                //        vDieuLuat.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                //        vDieuLuat.NGAYTAO = DateTime.Now;
                                //        vDieuLuat.TOIDANHID = vDieuLuat_OLD.TOIDANHID;
                                //        vDieuLuat.VUANID = oVUAN_new.ID;
                                //        vDieuLuat.TENTOIDANH = vDieuLuat_OLD.TENTOIDANH;
                                //        vDieuLuat.ISMAIN = vDieuLuat_OLD.ISMAIN;
                                //        dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Add(vDieuLuat);
                                //        dt.SaveChanges();
                                //    }
                                //    //Bien phap ngan chan
                                //    List<AHS_SOTHAM_BIENPHAPNGANCHAN> List_BienPhap = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.VUANID == VuAnID && x.BICANID == vbicao.ID).ToList<AHS_SOTHAM_BIENPHAPNGANCHAN>();
                                //    foreach (AHS_SOTHAM_BIENPHAPNGANCHAN vBienPhap_OLD in List_BienPhap)
                                //    {
                                //        AHS_SOTHAM_BIENPHAPNGANCHAN vBienPhap_new = new AHS_SOTHAM_BIENPHAPNGANCHAN();
                                //        vBienPhap_new.BICANID = oBiCao_new.ID;
                                //        vBienPhap_new.DONVIRAQD = vBienPhap_OLD.DONVIRAQD;
                                //        vBienPhap_new.BIENPHAPNGANCHANID = vBienPhap_OLD.BIENPHAPNGANCHANID;
                                //        vBienPhap_new.HIEULUC = vBienPhap_OLD.HIEULUC;
                                //        vBienPhap_new.NGAYBATDAU = vBienPhap_OLD.NGAYBATDAU;
                                //        vBienPhap_new.NGAYKETTHUC = vBienPhap_OLD.NGAYKETTHUC;
                                //        vBienPhap_new.GHICHU = vBienPhap_OLD.GHICHU;
                                //        vBienPhap_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                //        vBienPhap_new.NGAYTAO = DateTime.Now;
                                //        vBienPhap_new.VUANID = oVUAN_new.ID;
                                //        vBienPhap_new.FILEID = vBienPhap_OLD.FILEID;
                                //        vBienPhap_new.TENFILE = vBienPhap_OLD.TENFILE;
                                //        vBienPhap_new.SOQD = vBienPhap_OLD.SOQD;
                                //        vBienPhap_new.NGAYQD = vBienPhap_OLD.NGAYQD;
                                //        vBienPhap_new.KIEUFILE = vBienPhap_OLD.KIEUFILE;
                                //        vBienPhap_new.NOIDUNGFILE = vBienPhap_OLD.NOIDUNGFILE;
                                //        vBienPhap_new.GIAIDOANAPDUNG = vBienPhap_OLD.GIAIDOANAPDUNG;
                                //        vBienPhap_new.NOIGIAMGIU = vBienPhap_OLD.NOIGIAMGIU;
                                //        dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Add(vBienPhap_new);
                                //        dt.SaveChanges();
                                //    }
                                //}
                                ////Bi hai
                                //List<AHS_NGUOITHAMGIATOTUNG> List_Bihai = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID).ToList<AHS_NGUOITHAMGIATOTUNG>();
                                //foreach (AHS_NGUOITHAMGIATOTUNG vBiHai_OLD in List_Bihai)
                                //{
                                //    AHS_NGUOITHAMGIATOTUNG_TUCACH obj = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == vBiHai_OLD.ID && x.TUCACHID == 122).FirstOrDefault<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
                                //    if (obj != null)
                                //    {
                                //        AHS_NGUOITHAMGIATOTUNG vBiHai_new = new AHS_NGUOITHAMGIATOTUNG();
                                //        vBiHai_new.VUANID = oVUAN_new.ID;
                                //        vBiHai_new.HOTEN = vBiHai_OLD.HOTEN;
                                //        vBiHai_new.DIACHIID = vBiHai_OLD.DIACHIID;
                                //        vBiHai_new.DIACHICHITIET = vBiHai_OLD.DIACHICHITIET;
                                //        vBiHai_new.GIOITINH = vBiHai_OLD.GIOITINH;
                                //        vBiHai_new.NGAYSINH = vBiHai_OLD.NGAYSINH;
                                //        vBiHai_new.THANGSINH = vBiHai_OLD.THANGSINH;
                                //        vBiHai_new.NAMSINH = vBiHai_OLD.NAMSINH;
                                //        vBiHai_new.NGHENGHIEPID = vBiHai_OLD.NGHENGHIEPID;
                                //        vBiHai_new.CHUCVU = vBiHai_OLD.CHUCVU;
                                //        vBiHai_new.NGAYTHAMGIA = vBiHai_OLD.NGAYTHAMGIA;
                                //        vBiHai_new.NGAYKETTHUC = vBiHai_OLD.NGAYKETTHUC;
                                //        vBiHai_new.GHICHU = vBiHai_OLD.GHICHU;
                                //        vBiHai_new.ISHOSO = vBiHai_OLD.ISHOSO;
                                //        vBiHai_new.ISSOTHAM = vBiHai_OLD.ISSOTHAM;
                                //        vBiHai_new.ISPHUCTHAM = vBiHai_OLD.ISPHUCTHAM;
                                //        vBiHai_new.ISTREVITHANHNIEN = vBiHai_OLD.ISTREVITHANHNIEN;
                                //        vBiHai_new.LOAITREVITHANHNIEN = vBiHai_OLD.LOAITREVITHANHNIEN;
                                //        vBiHai_new.LOAIDT = vBiHai_OLD.LOAIDT;
                                //        vBiHai_new.NDD_HOTEN = vBiHai_OLD.NDD_HOTEN;
                                //        vBiHai_new.NDD_CHUCVU = vBiHai_OLD.NDD_CHUCVU;
                                //        vBiHai_new.NDD_CMND = vBiHai_OLD.NDD_CMND;
                                //        vBiHai_new.NDD_MOBILE = vBiHai_OLD.NDD_MOBILE;
                                //        vBiHai_new.NDD_EMAIL = vBiHai_OLD.NDD_EMAIL;
                                //        vBiHai_new.FILEID = vBiHai_OLD.FILEID;
                                //        vBiHai_new.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                //        vBiHai_new.NGAYSUA = DateTime.Now;
                                //        vBiHai_new.ID_NGUOITGTT_QLTACC = vBiHai_OLD.ID_NGUOITGTT_QLTACC;
                                //        dt.AHS_NGUOITHAMGIATOTUNG.Add(vBiHai_new);
                                //        dt.SaveChanges();

                                //        AHS_NGUOITHAMGIATOTUNG_TUCACH vBihai_TuCach = new AHS_NGUOITHAMGIATOTUNG_TUCACH();
                                //        vBihai_TuCach.NGUOIID = vBiHai_new.ID;
                                //        vBihai_TuCach.TUCACHID = 122;
                                //        dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Add(vBihai_TuCach);
                                //        dt.SaveChanges();
                                //    }

                                //}

                                oT.MAP_VUANID_NEW = oVUAN_new.ID;
                                List<AHS_CHUYEN_NHAN_AN_KCKN> listKCKN = DataExtensions.GetAllWithClause<AHS_CHUYEN_NHAN_AN_KCKN>($"CHUYENNHANID = {ChuyenNhanAnID}").ToList();
                                foreach (var mapkckn in listKCKN)
                                {
                                    AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST obnew = new AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST()
                                    {
                                        IS_KC = mapkckn.ISKC,
                                        KCKN_SOTHAM_ID = mapkckn.KCKNID,
                                        NGAY_TAO = DateTime.Now,
                                        NHANANID = ChuyenNhanAnID,
                                        TRANG_THAI_ID = 1,
                                        VUANPT_ID = oVUAN_new.ID,
                                        VUANST_ID = oVuAn.ID
                                    };
                                    DataExtensions.Insert(obnew);
                                }

                                #endregion tạo mới đơn trên phúc thẩm tđc

                                oVuAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            }

                            #endregion toancau anhnt-nhận án có kháng cáo kháng nghị tạm đình chỉ
                        }
                        else
                        {
                            //anhvh add 26/06/2020
                            GD.GAIDOAN_INSERT_UPDATE("1", VuAnID, ENUM_GIAIDOANVUAN.PHUCTHAM, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
                        }
                    }
                    oT.TRANGTHAI = 1;// 0: Chuyển chờ nhận, 1: Nhận
                    oT.NGAYGIAO = (String.IsNullOrEmpty(txtN_Ngaygiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtN_Ngaygiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.NGAYNHAN = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.NGUOINHANID = Convert.ToDecimal(ddlN_Nguoinhan.SelectedValue);
                    oT.NGUOITAO_PHUCTHAM = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.NGAYTAO_PHUCTHAM = DateTime.Now;
                    oT.NGAYSUA = DateTime.Now;
                    dt.SaveChanges();
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    lbthongbaoNA.Text = "Nhận án thành công !";
                    pnDanhsach.Visible = true;
                    pnCapnhat.Visible = false;
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

        private void UpdateThuLy(THU_LY _ThuLy, decimal ToaThuLy, decimal VuAnID, string CapXetXu)
        {
            if (CapXetXu == "SOTHAM")
            {
                // Update thụ lý sơ thẩm
                bool IsNew = false;
                AHS_SOTHAM_THULY STThuLy = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID && x.SOTHULY == _ThuLy.SOTHULY.ToString()).FirstOrDefault();
                if (STThuLy != null)
                {
                    IsNew = true;
                    STThuLy = new AHS_SOTHAM_THULY();
                }
                STThuLy.VUANID = VuAnID;
                STThuLy.SOTHULY = _ThuLy.SOTHULY.ToString();
                DateTime NgayThuLy = DateTime.MinValue;
                if (DateTime.TryParseExact(_ThuLy.NGAYTHULY, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayThuLy))
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
                    STThuLy.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHS_SOTHAM_THULY.Add(STThuLy);
                }
                dt.SaveChanges();
            }
            else
            {
                // Update thụ lý phúc thẩm
                bool IsNew = false;
                AHS_PHUCTHAM_THULY PTThuLy = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == VuAnID && x.SOTHULY == _ThuLy.SOTHULY.ToString()).FirstOrDefault();
                if (PTThuLy != null)
                {
                    IsNew = true;
                    PTThuLy = new AHS_PHUCTHAM_THULY();
                }
                PTThuLy.VUANID = VuAnID;
                PTThuLy.SOTHULY = _ThuLy.SOTHULY.ToString();
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
                if (DateTime.TryParseExact(_ThuLy.NGAYTHULY, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayThuLy))
                {
                    PTThuLy.NGAYTHULY = NgayThuLy;
                }
                else
                {
                    PTThuLy.NGAYTHULY = (DateTime?)null;
                }
                PTThuLy.TOAANID = ToaThuLy;
                if (IsNew)
                {
                    PTThuLy.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHS_PHUCTHAM_THULY.Add(PTThuLy);
                }
                dt.SaveChanges();
            }
        }

        private void UpdateBiCanBiCao(List<NGUOI_THAM_GIA_AHS> List_BiCao_ToiDanh, decimal VuAnID)
        {
            if (List_BiCao_ToiDanh.Count > 0)
            {
                bool IsNew = false;
                DM_BOLUAT_TOIDANH dm_BLuat_ToiDanh = null;
                foreach (NGUOI_THAM_GIA_AHS item in List_BiCao_ToiDanh)
                {
                    #region Update bị can, bị cáo - Table AHS_BICANBICAO

                    IsNew = false;
                    byte[] BiCaoID_TACC = item.Guid;
                    AHS_BICANBICAO _BICANBICAO = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.BICANBICAOID_TACC == BiCaoID_TACC).FirstOrDefault();
                    if (_BICANBICAO == null)
                    {
                        IsNew = true;
                        _BICANBICAO = new AHS_BICANBICAO();
                    }
                    _BICANBICAO.VUANID = VuAnID;
                    _BICANBICAO.BICANBICAOID_TACC = BiCaoID_TACC;
                    _BICANBICAO.BICANDAUVU = Convert.ToDecimal(item.ISDAUVU);
                    _BICANBICAO.HOTEN = item.TENBICAO;
                    DateTime NgaySinh = DateTime.MinValue;
                    if (DateTime.TryParseExact(item.NGAYSINH, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgaySinh))
                    {
                        _BICANBICAO.NGAYSINH = NgaySinh;
                    }
                    else
                    {
                        _BICANBICAO.NGAYSINH = (DateTime?)null;
                    }
                    _BICANBICAO.NAMSINH = item.NAMSINH + "" == "" ? 0 : Convert.ToDecimal(item.NAMSINH);
                    _BICANBICAO.GIOITINH = item.GIOITINH + "" == "" ? 0 : Convert.ToDecimal(item.GIOITINH);
                    _BICANBICAO.QUOCTICHID = item.QUOCTICH + "" == "" ? 0 : Convert.ToDecimal(item.QUOCTICH);
                    _BICANBICAO.HKTT = item.MA_TINH + "" == "" ? 0 : Convert.ToDecimal(item.MA_TINH);
                    _BICANBICAO.HKTT_HUYEN = item.MA_HUYEN + "" == "" ? 0 : Convert.ToDecimal(item.MA_HUYEN);
                    _BICANBICAO.KHTTCHITIET = item.DIACHICHITIET + "";
                    if (IsNew)
                    {
                        _BICANBICAO.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.AHS_BICANBICAO.Add(_BICANBICAO);
                    }
                    dt.SaveChanges();

                    #endregion Update bị can, bị cáo - Table AHS_BICANBICAO

                    #region Update Tội danh - Table AHS_SOTHAM_CAOTRANG_DIEULUAT

                    IsNew = false;
                    TOIDANH _ToiDanh = item.VTOIDANH;
                    if (_ToiDanh.HINHPHATCHINH > 0)
                    {
                        AHS_SOTHAM_CAOTRANG_DIEULUAT _CaoTrang_DL = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == _BICANBICAO.ID && x.DIEULUATID == _ToiDanh.DIEU && x.TOIDANHID == _ToiDanh.HINHPHATCHINH && x.ISMAIN == 1).FirstOrDefault();
                        if (_CaoTrang_DL == null)
                        {
                            IsNew = true;
                            _CaoTrang_DL = new AHS_SOTHAM_CAOTRANG_DIEULUAT
                            {
                                NGAYTAO = DateTime.Now
                            };
                        }
                        _CaoTrang_DL.BICANID = _BICANBICAO.ID;
                        _CaoTrang_DL.CAOTRANGID = 0;
                        _CaoTrang_DL.DIEULUATID = _ToiDanh.DIEU;
                        _CaoTrang_DL.ISMAIN = 1;
                        _CaoTrang_DL.TOIDANHID = _ToiDanh.HINHPHATCHINH;
                        _CaoTrang_DL.VUANID = VuAnID;
                        dm_BLuat_ToiDanh = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == _CaoTrang_DL.TOIDANHID).FirstOrDefault();
                        if (dm_BLuat_ToiDanh != null)
                        {
                            _CaoTrang_DL.TENTOIDANH = dm_BLuat_ToiDanh.TENTOIDANH;
                        }
                        if (IsNew)
                        {
                            dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Add(_CaoTrang_DL);
                        }
                        else
                        {
                            _CaoTrang_DL.NGAYSUA = DateTime.Now;
                        }
                        dt.SaveChanges();
                    }
                    else // Hình phạt bổ sung
                    {
                        AHS_SOTHAM_CAOTRANG_DIEULUAT _CaoTrang_DL = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == _BICANBICAO.ID && x.DIEULUATID == _ToiDanh.DIEU && x.TOIDANHID == Convert.ToDecimal(_ToiDanh.HINHPHATBOSUNG) && x.ISMAIN == 0).FirstOrDefault();
                        if (_CaoTrang_DL == null)
                        {
                            IsNew = true;
                            _CaoTrang_DL = new AHS_SOTHAM_CAOTRANG_DIEULUAT
                            {
                                NGAYTAO = DateTime.Now
                            };
                        }
                        _CaoTrang_DL.BICANID = _BICANBICAO.ID;
                        _CaoTrang_DL.CAOTRANGID = 0;
                        _CaoTrang_DL.DIEULUATID = _ToiDanh.DIEU;
                        _CaoTrang_DL.ISMAIN = 0;
                        _CaoTrang_DL.TOIDANHID = Convert.ToDecimal(_ToiDanh.HINHPHATBOSUNG);
                        _CaoTrang_DL.VUANID = VuAnID;
                        dm_BLuat_ToiDanh = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == _CaoTrang_DL.TOIDANHID).FirstOrDefault();
                        if (dm_BLuat_ToiDanh != null)
                        {
                            _CaoTrang_DL.TENTOIDANH = dm_BLuat_ToiDanh.TENTOIDANH;
                        }
                        if (IsNew)
                        {
                            dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Add(_CaoTrang_DL);
                        }
                        else
                        {
                            _CaoTrang_DL.NGAYSUA = DateTime.Now;
                        }
                        dt.SaveChanges();
                    }

                    #endregion Update Tội danh - Table AHS_SOTHAM_CAOTRANG_DIEULUAT

                    #region Update Biện pháp ngăn chặn - Table AHS_SOTHAM_BIENPHAPNGANCHAN

                    // Kiểm tra nếu có ngày hiệu lực của lệnh tạm giam
                    LENHTAMGIAM lenhTG = item.VLENHTAMGIAM;
                    if (lenhTG.HIEULUCDENNGAY != "")
                    {
                        IsNew = false;
                        AHS_SOTHAM_BIENPHAPNGANCHAN bPhapNganChan = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.BICANID == _BICANBICAO.ID && x.VUANID == VuAnID).FirstOrDefault();
                        if (bPhapNganChan == null)
                        {
                            IsNew = true;
                            bPhapNganChan = new AHS_SOTHAM_BIENPHAPNGANCHAN
                            {
                                NGAYTAO = DateTime.Now
                            };
                        }
                        else
                        {
                            bPhapNganChan.NGAYSUA = DateTime.Now;
                        }
                        bPhapNganChan.BICANID = _BICANBICAO.ID;
                        DM_DATAGROUP GroupDVQD = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.LOAIDONVIQDNGANCHAN).FirstOrDefault();
                        if (GroupDVQD != null)
                        {
                            DM_DATAITEM DVQD = dt.DM_DATAITEM.Where(x => x.GROUPID == GroupDVQD.ID && x.MA == "DVQD_VKS").FirstOrDefault();
                            if (DVQD != null)
                            {
                                bPhapNganChan.DONVIRAQD = DVQD.ID;
                            }
                        }
                        bPhapNganChan.VUANID = VuAnID;
                        DM_DATAGROUP GropBPNC = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.BIENPHAPNGANCHAN).FirstOrDefault();
                        if (GropBPNC != null)
                        {
                            DM_DATAITEM BPNC = dt.DM_DATAITEM.Where(x => x.GROUPID == GropBPNC.ID && x.MA == "BPNC_01").FirstOrDefault();
                            if (BPNC != null)
                            {
                                bPhapNganChan.BIENPHAPNGANCHANID = BPNC.ID;
                            }
                        }
                        bPhapNganChan.HIEULUC = 1;
                        DateTime NgayBatDau = DateTime.MinValue, NgayKetThuc = DateTime.MinValue;
                        if (DateTime.TryParseExact(lenhTG.HIEULUCTUNGAY, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayBatDau))
                        {
                            bPhapNganChan.NGAYBATDAU = NgayBatDau;
                        }
                        else
                        {
                            bPhapNganChan.NGAYBATDAU = (DateTime?)null;
                        }
                        if (DateTime.TryParseExact(lenhTG.HIEULUCDENNGAY, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayKetThuc))
                        {
                            bPhapNganChan.NGAYKETTHUC = NgayKetThuc;
                        }
                        else
                        {
                            bPhapNganChan.NGAYKETTHUC = (DateTime?)null;
                        }
                    }

                    #endregion Update Biện pháp ngăn chặn - Table AHS_SOTHAM_BIENPHAPNGANCHAN
                }
            }
        }

        private void UpdateNguoiTGTT(List<NGUOI_THAM_GIA_CHUNG> ListNguoiTGTT, decimal VuAnID)
        {
            if (ListNguoiTGTT.Count > 0)
            {
                bool IsNew = false;
                foreach (NGUOI_THAM_GIA_CHUNG item in ListNguoiTGTT)
                {
                    #region Update người tham gia tố tụng

                    AHS_NGUOITHAMGIATOTUNG NguoiTGTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID && x.ID_NGUOITGTT_QLTACC == item.Guid).FirstOrDefault();
                    if (NguoiTGTT != null)
                    {
                        IsNew = true;
                        NguoiTGTT = new AHS_NGUOITHAMGIATOTUNG();
                    }
                    NguoiTGTT.VUANID = VuAnID;
                    NguoiTGTT.ID_NGUOITGTT_QLTACC = item.Guid;
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
                    NguoiTGTT.LOAIDT = item.LOAIDUONGSU == "CANHAN" ? 0 : item.LOAIDUONGSU == "COQUAN" ? 1 : 2;
                    if (NguoiTGTT.LOAIDT > 0)
                    {
                        NguoiTGTT.NDD_HOTEN = item.NGUOIDAIDIEN;
                    }
                    if (IsNew)
                    {
                        // update toa_gq_id
                        NguoiTGTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.AHS_NGUOITHAMGIATOTUNG.Add(NguoiTGTT);
                    }
                    dt.SaveChanges();

                    #endregion Update người tham gia tố tụng

                    #region Update Tư cách tham gia tố tụng

                    IsNew = false;
                    AHS_NGUOITHAMGIATOTUNG_TUCACH TuCach = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == NguoiTGTT.ID).FirstOrDefault();
                    if (TuCach == null)
                    {
                        IsNew = true;
                        TuCach = new AHS_NGUOITHAMGIATOTUNG_TUCACH();
                    }
                    TuCach.NGUOIID = NguoiTGTT.ID;
                    TuCach.TUCACHID = item.TUCACHTOTUNG + "" == "" ? 0 : Convert.ToDecimal(item.TUCACHTOTUNG);
                    if (IsNew)
                    {
                        dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Add(TuCach);
                    }
                    dt.SaveChanges();

                    #endregion Update Tư cách tham gia tố tụng
                }
            }
        }

        private void UpdateNguoiTHTT(List<NGUOI_TIEN_HANH_TO_TUNG> ListNguoiTHTT, decimal VuAnID, string CapXetXu)
        {
            if (ListNguoiTHTT.Count > 0)
            {
                bool IsNew = false;
                foreach (NGUOI_TIEN_HANH_TO_TUNG item in ListNguoiTHTT)
                {
                    decimal CanBoID = item.MACANBO + "" == "" ? 0 : Convert.ToDecimal(item.MACANBO);
                    if (CapXetXu == "SOTHAM")
                    {
                        AHS_SOTHAM_HDXX Hdxx = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.CANBOID == CanBoID).FirstOrDefault();
                        if (Hdxx == null)
                        {
                            IsNew = true;
                            Hdxx = new AHS_SOTHAM_HDXX();
                        }
                        Hdxx.VUANID = VuAnID;
                        Hdxx.CANBOID = CanBoID;
                        Hdxx.HOTEN = item.TENCANBO;
                        Hdxx.MAVAITRO = item.TUCACHTOTUNG;
                        if (IsNew)
                        {
                            // insert toa_gq_id
                            Hdxx.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.AHS_SOTHAM_HDXX.Add(Hdxx);
                        }
                        dt.SaveChanges();
                    }
                    // Phúc thẩm
                    else
                    {
                        AHS_PHUCTHAM_HDXX Hdxx = dt.AHS_PHUCTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.CANBOID == CanBoID).FirstOrDefault();
                        if (Hdxx == null)
                        {
                            IsNew = true;
                            Hdxx = new AHS_PHUCTHAM_HDXX();
                        }
                        Hdxx.VUANID = VuAnID;
                        Hdxx.CANBOID = CanBoID;
                        Hdxx.HOTEN = item.TENCANBO;
                        Hdxx.MAVAITRO = item.TUCACHTOTUNG;
                        if (IsNew)
                        {
                            Hdxx.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.AHS_PHUCTHAM_HDXX.Add(Hdxx);
                        }
                        dt.SaveChanges();
                    }
                }
            }
        }

        private void UpdateQDVuAn(List<QUYET_DINH> ListQD, decimal ToaAnID, decimal VuAnID, string CapXetXu)
        {
            if (ListQD.Count > 0)
            {
                bool IsNew = false;
                foreach (QUYET_DINH item in ListQD)
                {
                    decimal NguoiKyID = item.NGUOIKY + "" == "" ? 0 : Convert.ToDecimal(item.NGUOIKY);
                    if (CapXetXu == "SOTHAM")
                    {
                        AHS_SOTHAM_QUYETDINH_VUAN QdVuAn = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID && x.DONVIID == ToaAnID).FirstOrDefault();
                        if (QdVuAn == null)
                        {
                            IsNew = false;
                            QdVuAn = new AHS_SOTHAM_QUYETDINH_VUAN()
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
                        QdVuAn.VUANID = VuAnID;
                        QdVuAn.LOAIQDID = LoaiQDID;
                        QdVuAn.QUYETDINHID = QDID;
                        QdVuAn.DONVIID = ToaAnID;
                        QdVuAn.SOQUYETDINH = item.SOQUYETDINH;
                        DateTime NgayQD = DateTime.MinValue;
                        if (DateTime.TryParseExact(item.NGAYQUYETDINH, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayQD))
                        {
                            QdVuAn.NGAYQD = NgayQD;
                        }
                        QdVuAn.NGUOIKYID = NguoiKyID;
                        if (IsNew)
                        {
                            // insert toa_gq_id
                            if(QdVuAn.TOA_GIAIQUYET_ID == null)
                                QdVuAn.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.AHS_SOTHAM_QUYETDINH_VUAN.Add(QdVuAn);
                        }
                        dt.SaveChanges();
                    }
                    // Phúc thẩm
                    else
                    {
                        AHS_PHUCTHAM_QUYETDINH_VUAN QdVuAn = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID && x.DONVIID == ToaAnID).FirstOrDefault();
                        if (QdVuAn == null)
                        {
                            IsNew = false;
                            QdVuAn = new AHS_PHUCTHAM_QUYETDINH_VUAN()
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
                        QdVuAn.VUANID = VuAnID;
                        QdVuAn.LOAIQDID = LoaiQDID;
                        QdVuAn.QUYETDINHID = QDID;
                        QdVuAn.DONVIID = ToaAnID;
                        QdVuAn.SOQUYETDINH = item.SOQUYETDINH;
                        DateTime NgayQD = DateTime.MinValue;
                        if (DateTime.TryParseExact(item.NGAYQUYETDINH, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayQD))
                        {
                            QdVuAn.NGAYQD = NgayQD;
                        }
                        QdVuAn.NGUOIKYID = NguoiKyID;
                        if (IsNew)
                        {
                            // insert toa_gq_id
                            if(QdVuAn.TOA_GIAIQUYET_ID == null)
                                QdVuAn.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Add(QdVuAn);
                        }
                        dt.SaveChanges();
                    }
                }
            }
        }

        private void UpdateBanAn(BAN_AN bAn, LICH_XET_XU LichXetXu, decimal ToaAnID, decimal VuAnID, string CapXetXu)
        {
            bool IsNew = false;
            if (CapXetXu == "SOTHAM")
            {
                AHS_SOTHAM_BANAN STBanAn = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID && x.TOAANID == ToaAnID).FirstOrDefault();
                if (STBanAn == null)
                {
                    IsNew = true;
                    STBanAn = new AHS_SOTHAM_BANAN();
                    STBanAn.NGAYTAO = DateTime.Now;
                }
                else
                {
                    STBanAn.NGAYSUA = DateTime.Now;
                }
                STBanAn.VUANID = VuAnID;
                STBanAn.TOAANID = ToaAnID;
                STBanAn.SOBANAN = bAn.SOBANAN;
                DateTime NgayBanAn = DateTime.MinValue, NgayXetXu = DateTime.MinValue;
                if (DateTime.TryParseExact(bAn.NGAYBANAN, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayBanAn))
                {
                    STBanAn.NGAYBANAN = NgayBanAn;
                }
                if (DateTime.TryParseExact(LichXetXu.NGAYXETXU, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayXetXu))
                {
                    STBanAn.NGAYMOPHIENTOA = NgayXetXu;
                }
                STBanAn.DIADIEM = LichXetXu.DIADIEMXETXU;
                if (IsNew)
                {
                    // insert toa_gq_id
                    STBanAn.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHS_SOTHAM_BANAN.Add(STBanAn);
                }
                dt.SaveChanges();
            }
            // Phúc thẩm
            else
            {
                AHS_PHUCTHAM_BANAN PTBanAn = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == VuAnID && x.TOAANID == ToaAnID).FirstOrDefault();
                if (PTBanAn == null)
                {
                    IsNew = true;
                    PTBanAn = new AHS_PHUCTHAM_BANAN();
                    PTBanAn.NGAYTAO = DateTime.Now;
                }
                else
                {
                    PTBanAn.NGAYSUA = DateTime.Now;
                }
                PTBanAn.VUANID = VuAnID;
                PTBanAn.TOAANID = ToaAnID;
                PTBanAn.SOBANAN = bAn.SOBANAN;
                DateTime NgayBanAn = DateTime.MinValue, NgayXetXu = DateTime.MinValue;
                if (DateTime.TryParseExact(bAn.NGAYBANAN, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayBanAn))
                {
                    PTBanAn.NGAYBANAN = NgayBanAn;
                }
                if (DateTime.TryParseExact(LichXetXu.NGAYXETXU, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayXetXu))
                {
                    PTBanAn.NGAYMOPHIENTOA = NgayXetXu;
                }
                DM_KETQUA_PHUCTHAM KQPT = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ISAHS == 1 && x.MA == bAn.KETQUA).FirstOrDefault();
                if (KQPT != null)
                {
                    PTBanAn.KETQUAPHUCTHAMID = KQPT.ID;
                    DM_KETQUA_PHUCTHAM_LYDO LyDo = dt.DM_KETQUA_PHUCTHAM_LYDO.Where(x => x.KETQUAID == KQPT.ID && x.MA == bAn.LYDO).FirstOrDefault();
                    if (LyDo != null)
                    {
                        PTBanAn.LYDOBANANID = LyDo.ID;
                    }
                }
                PTBanAn.DIADIEM = LichXetXu.DIADIEMXETXU;
                if (IsNew)
                {
                    // insert toa_gq_id
                    PTBanAn.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHS_PHUCTHAM_BANAN.Add(PTBanAn);
                }
                dt.SaveChanges();
            }
        }

        private void UpdateKhangCao(List<KHANG_CAO> ListKhangCao, decimal ToaAnID, decimal VuAnID)
        {
            if (ListKhangCao.Count > 0)
            {
                bool IsNew = false;
                foreach (KHANG_CAO item in ListKhangCao)
                {
                    #region Lưu Nội dung kháng cáo

                    byte[] Guid_NguoiKC = item.GUID;
                    decimal NguoiKCID = 0, IsBiCan = 1;
                    AHS_BICANBICAO Bicao = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.BICANBICAOID_TACC == Guid_NguoiKC).FirstOrDefault();
                    if (Bicao != null)
                    {
                        NguoiKCID = Bicao.ID;
                        IsBiCan = 0;
                    }
                    AHS_SOTHAM_KHANGCAO kc = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.NGUOIKCID == NguoiKCID && x.TOAANRAQDID == ToaAnID).FirstOrDefault();
                    if (kc != null)
                    {
                        IsNew = true;
                        kc = new AHS_SOTHAM_KHANGCAO();
                        kc.NGAYTAO = DateTime.Now;
                    }
                    else
                    {
                        kc.NGAYSUA = DateTime.Now;
                    }
                    kc.VUANID = VuAnID;
                    kc.TOAANRAQDID = ToaAnID;
                    kc.NGUOIKCID = NguoiKCID;
                    kc.NGUOIKCLOAI = IsBiCan;
                    DateTime NgayKhangCao = DateTime.MinValue;
                    if (DateTime.TryParseExact(item.NGAYKHANGCAO, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayKhangCao))
                    {
                        kc.NGAYKHANGCAO = NgayKhangCao;
                    }
                    kc.NOIDUNGKHANGCAO = item.NOIDUNGKHANGCAO;
                    if (IsNew)
                    {
                        kc.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.AHS_SOTHAM_KHANGCAO.Add(kc);
                    }
                    dt.SaveChanges();

                    #endregion Lưu Nội dung kháng cáo

                    #region Lưu yêu cầu kháng cáo

                    decimal KCID = kc.ID;
                    DM_DATAGROUP GYeuCauKC = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.YEUCAUKCHINHSU).FirstOrDefault();
                    if (GYeuCauKC != null)
                    {
                        DM_DATAITEM DM_yckc = dt.DM_DATAITEM.Where(x => x.GROUPID == GYeuCauKC.ID && x.MA == item.YEUCAUKHANGCAO).FirstOrDefault();
                        if (DM_yckc != null)
                        {
                            IsNew = false;
                            AHS_SOTHAM_KHANGCAO_YEUCAU kcyc = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == KCID && x.YEUCAUID == DM_yckc.ID).FirstOrDefault();
                            if (kcyc == null)
                            {
                                IsNew = true;
                                kcyc = new AHS_SOTHAM_KHANGCAO_YEUCAU();
                                kcyc.NGAYTAO = DateTime.Now;
                            }
                            else
                            {
                                kcyc.NGAYSUA = DateTime.Now;
                            }
                            kcyc.KHANGCAOID = KCID;
                            kcyc.YEUCAUID = DM_yckc.ID;
                            if (IsNew)
                            {
                                dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Add(kcyc);
                            }
                            dt.SaveChanges();
                        }
                    }

                    #endregion Lưu yêu cầu kháng cáo
                }
            }
        }

        #endregion Phần lưu thông tin vụ án, vụ việc từ tòa cấp cao

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
                        //breAHS;
                    }
                }

                //decimal ChuyenNhanID = 0;
                //foreach (DataGridItem Item in dgList.Items)
                //{
                //    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                //    if (chkChon.Checked)
                //    {
                //        ChuyenNhanID = Convert.ToDecimal(chkChon.ToolTip);
                //        breAHS;
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
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                DataRowView rv = (DataRowView)e.Item.DataItem;

                LinkButton lbtHuyNhan = (LinkButton)e.Item.FindControl("lbtHuyNhan");

                Literal lttChitiet = (Literal)e.Item.FindControl("lttChitiet");
                lttChitiet.Text = "<a  style='color: red; font - weight:bold;' href='javascript:;' onclick='popup_chitiet(" + rv["V_VUANID"].ToString() + ',' + rv["V_MAVUAN"].ToString() + ");'>Chi tiết >></a>";

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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_CVA_KHONG_THAM_QUYEN", parameters);
            decimal Result = 0;
            if (tbl.Rows.Count > 0)
                Result = Convert.ToDecimal(tbl.Rows[0]["ID"]);
            return Result;
        }

        private void HuyNhan(List<decimal> lstDonID)
        {
            AHS_VUAN_BL Bl = new AHS_VUAN_BL();
            AHS_CHUYEN_NHAN_AN_BL _chuyenNhanBl = new AHS_CHUYEN_NHAN_AN_BL();
            for (int i = 0; i < lstDonID.Count; i++)
            {
                var ChuyenNhanID = lstDonID[i];
                decimal DonID_New = 0;
                AHS_CHUYEN_NHAN_AN ObjChuyenAn = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.ID == ChuyenNhanID).FirstOrDefault();
                if (ObjChuyenAn != null)
                {
                    //MAP_VUANID_NEW khi chuyen an không thuộc thẩm quyền thì sẽ sinh Vụ án mới
                    if (ObjChuyenAn.MAP_VUANID_NEW != null)
                    {
                        if (Convert.ToDecimal(ObjChuyenAn.MAP_VUANID_NEW) > 0)
                            DonID_New = Convert.ToDecimal(ObjChuyenAn.MAP_VUANID_NEW);
                    }
                }
                bool IsThuLy;
                if (DonID_New > 0)
                { //Sinh vụ án mới
                    IsThuLy = _chuyenNhanBl.Check_ThuLy(DonID_New, 1);
                }
                else
                {
                    //Chuyển án khi có kháng cáo
                    IsThuLy = _chuyenNhanBl.Check_ThuLy(Convert.ToDecimal(ObjChuyenAn.VUANID), 0);
                }

                if (IsThuLy)
                {
                    lbthongbao.Text = "Án đã được thụ lý. Không được phép hủy nhận án.";
                    return;
                }
            }

            for (int i = 0; i < lstDonID.Count; i++)
            {
                var ChuyenNhanID = lstDonID[i];
                decimal DonID_New = 0;
                AHS_CHUYEN_NHAN_AN ObjChuyenAn = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.ID == ChuyenNhanID).FirstOrDefault();
                bool IsThuLy;
                if (ObjChuyenAn != null)
                {
                    if (ObjChuyenAn.MAP_VUANID_NEW.GetValueOrDefault(0) > 0)
                    {
                        DonID_New = Convert.ToDecimal(ObjChuyenAn.MAP_VUANID_NEW);
                        IsThuLy = _chuyenNhanBl.Check_ThuLy(DonID_New, 1);
                        if (!IsThuLy)
                        {
                            if (ObjChuyenAn != null)
                            {
                                ObjChuyenAn.MAP_VUANID_NEW = null;
                                ObjChuyenAn.TRANGTHAI = 0;
                                ObjChuyenAn.NGAYNHAN = null;
                                dt.SaveChanges();
                            }
                            Bl.DELETE_ALLDATA_BY_VUANID(DonID_New.ToString());

                            GIAI_DOAN_BL gdbl = new GIAI_DOAN_BL();
                            int LoaiVuViec = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_HINHSU);
                            AHS_VUAN oVuan = dt.AHS_VUAN.Where(x => x.ID == ObjChuyenAn.VUANID).FirstOrDefault();
                            if (DonID_New > 0)
                                gdbl.GIAIDOAN_DELETES(LoaiVuViec.ToString(), DonID_New, Convert.ToDecimal(oVuan.MAGIAIDOAN));
                            else
                                gdbl.GIAIDOAN_DELETES(LoaiVuViec.ToString(), Convert.ToDecimal(ObjChuyenAn.VUANID), Convert.ToDecimal(oVuan.MAGIAIDOAN));
                            if (oVuan.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                                oVuan.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            dt.SaveChanges();
                        }
                        else
                        {
                            lbthongbao.Text = "Án đã được thụ lý. Không được phép hủy nhận án.";
                        }
                    }
                    else
                    {
                        //Chuyển án khi có kháng cáo

                        AHS_VUAN oVuan = dt.AHS_VUAN.Where(x => x.ID == ObjChuyenAn.VUANID).FirstOrDefault();
                        if (oVuan.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                        {
                            AHS_CHUYEN_NHAN_AN_BL _chuyenNhanAnBl = new AHS_CHUYEN_NHAN_AN_BL();
                            var oldVuAnId = _chuyenNhanAnBl.getDonIdOld(oVuan.ID);
                            //lay chuyen an tu st len pt tdc
                            AHS_CHUYEN_NHAN_AN chuyenAnSTlenPTTDC = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == oVuan.ID).FirstOrDefault();
                            List<AHS_SOTHAM_THULY> oThuLyST = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<AHS_SOTHAM_HDXX> oSTNguoiTienHanhToTung = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<AHS_THAMPHANGIAIQUYET> oThamPhanST = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<AHS_SOTHAM_BANAN> oBanAnST = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<AHS_THAMPHANGIAIQUYET> oQDST = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<AHS_SOTHAM_KHANGCAO> oKCST = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<AHS_SOTHAM_KHANGNGHI> oKNST = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();

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
                                List<AHS_CHUYEN_NHAN_AN_KCKN> lstKCKN = DataExtensions.GetAllWithClause<AHS_CHUYEN_NHAN_AN_KCKN>($"CHUYENNHANID = {chuyenAnSTlenPTTDC.ID}").ToList();
                                if (lstKCKN != null && lstKCKN.Count > 0)
                                {
                                    foreach (var item in lstKCKN)
                                    {
                                        if (item.ISKC == 1)
                                        {
                                            AHS_SOTHAM_KHANGCAO khangCao = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == item.KCKNID).FirstOrDefault();
                                            if (khangCao != null)
                                            {
                                                khangCao.TINHTRANG_GIAIQUYET = 0;
                                                dt.SaveChanges();
                                            }
                                        }
                                        else
                                        {
                                            AHS_SOTHAM_KHANGNGHI khangNghi = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == item.KCKNID).FirstOrDefault();
                                            if (khangNghi != null)
                                            {
                                                khangNghi.TINHTRANG_GIAIQUYET = 0;
                                                dt.SaveChanges();
                                            }
                                        }
                                    }
                                }
                                AHS_VUAN oVuAnOld = dt.AHS_VUAN.Where(x => x.ID == oldVuAnId).FirstOrDefault();
                                ObjChuyenAn.TRANGTHAI = 0;
                                ObjChuyenAn.NGAYNHAN = null;
                                if (oVuAnOld != null)
                                    oVuAnOld.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                                dt.SaveChanges();
                            }
                        }
                        else
                        {
                            IsThuLy = _chuyenNhanBl.Check_ThuLy(Convert.ToDecimal(ObjChuyenAn.VUANID), 0);
                            if (ObjChuyenAn != null)
                            {
                                ObjChuyenAn.MAP_VUANID_NEW = null;
                                ObjChuyenAn.TRANGTHAI = 0;
                                dt.SaveChanges();
                            }
                            Bl.DELETE_ALLDATA_BY_VUANID(DonID_New.ToString());

                            GIAI_DOAN_BL gdbl = new GIAI_DOAN_BL();
                            int LoaiVuViec = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_HINHSU);

                            if (DonID_New > 0)
                                gdbl.GIAIDOAN_DELETES(LoaiVuViec.ToString(), DonID_New, Convert.ToDecimal(oVuan.MAGIAIDOAN));
                            else
                                gdbl.GIAIDOAN_DELETES(LoaiVuViec.ToString(), Convert.ToDecimal(ObjChuyenAn.VUANID), Convert.ToDecimal(oVuan.MAGIAIDOAN));
                            if (oVuan.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                                oVuan.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            dt.SaveChanges();
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
    }
}