using BL.GSTP;
using BL.GSTP.XLHC;
using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.GSTP.Models;
using BL.GSTP.QLAN;
using NLog;

namespace WEB.GSTP.QLAN.XLHC.ChuyenNhanAn
{
    public partial class NhanAn : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal DA_CHUYEN = 0, DA_NHAN = 1;
        private const string CONNECTION_TO_DB_TRUNGGIAN = "DB_TRUNG_GIAN_Connection";
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    // Tạm thời COMMENT Chờ kết nối
                    #region Quét các vụ việc được chuyển từ Tòa án cấp cao và lưu vào XLHC_DON và XLHC_CHUYEN_NHAN_AN
                    //decimal ToaAnID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
                    //// Tòa án cấp cao: TRANG_THAI=1: Đã chuyển; TRANG_THAI=2: Đã nhận
                    //string sql = "select * from HOSO where TOA_AN_XET_XU='" + ToaAnID.ToString() + "' and LOAI_AN='" + ENUM_LOAIAN.BPXLHC + "' and TRANG_THAI=1";
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
                    //        #region Update Vụ việc XLHC_DON
                    //        XLHC_DON vDON = dt.XLHC_DON.Where(x => x.MAVUVIEC == MaVuViec && ((x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && x.TOAANID == ToaAnID) || (x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && x.TOAPHUCTHAMID == ToaAnID))).FirstOrDefault();
                    //        if (vDON == null)
                    //        {
                    //            IsNew = true;
                    //            vDON = new XLHC_DON();
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
                    //            dt.XLHC_DON.Add(vDON);
                    //        }
                    //        dt.SaveChanges();
                    //        VuAnID = vDON.ID;
                    //        #endregion
                    //        #region Update Table XLHC_CHUYEN_NHAN_AN
                    //        IsNew = false;
                    //        XLHC_CHUYEN_NHAN_AN chuyen_nhan_an = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID && x.TOACHUYENID == Toa_Chuyen_ID && x.TOANHANID == Toa_Nhan_ID).FirstOrDefault();
                    //        if (chuyen_nhan_an == null)
                    //        {
                    //            IsNew = true;
                    //            chuyen_nhan_an = new XLHC_CHUYEN_NHAN_AN();
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
                    //            dt.XLHC_CHUYEN_NHAN_AN.Add(chuyen_nhan_an);
                    //        }
                    //        dt.SaveChanges();
                    //        #endregion
                    //    }
                    //}
                    #endregion
                    LoadTHGiaoNhan();
                    LoadCanBo();
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    Cls_Comon.SetButton(cmdNhanan, false);
                    Cls_Comon.SetButton(cmdHuyNhan, false);
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
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
        private void LoadCanBo()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlN_Nguoinhan.DataSource = oCBDT;
            ddlN_Nguoinhan.DataTextField = "MA_TEN";
            ddlN_Nguoinhan.DataValueField = "ID";
            ddlN_Nguoinhan.DataBind();
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
            DataTable oDT = oBL.XLHC_NHANAN_V2(txtSoQD.Text.Trim(), txt_NgayQD.Text.Trim(), vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, txtTenToa.Text, Convert.ToDecimal(ddlTHGN.SelectedValue), dFrom, dTo, Convert.ToDecimal(rdbTrangthai.SelectedValue));
 
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
            lbthongbao.Text = "";
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    hddVuViecID.Value = Item.Cells[0].Text;
                    txtN_Mavuviec.Text = Item.Cells[1].Text;
                    txtN_Tenvuviec.Text = Item.Cells[4].Text;
                    txtN_Ngaygiao.Text = Item.Cells[7].Text;
                    txtN_Toagiao.Text = Item.Cells[5].Text;
                    txtToanhan.Text = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    txtN_THGN.Text = Item.Cells[9].Text;
                    txtNgayNhan.Text = DateTime.Now.ToString("dd/MM/yyyy");
                }

            }
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
            CheckBox chkXem = (CheckBox)sender;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkXem.Checked)
                {
                    if (chkXem.ToolTip != chkChon.ToolTip) chkChon.Checked = false;
                }
            }
        }
        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            if (Cls_Comon.IsValidDate(txtNgayNhan.Text) == false)
            {
                lbthongbaoNA.Text = "Bạn phải nhập ngày nhận theo định dạng (dd/MM/yyyy).";
                txtNgayNhan.Focus();
                return;
            }
            decimal ID = Convert.ToDecimal(hddVuViecID.Value);
            XLHC_CHUYEN_NHAN_AN oT = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                decimal DonID = (decimal)oT.VUANID;
                //Cập nhật lại thông tin án
                XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DonID).FirstOrDefault();
                DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.ID == oT.TRUONGHOPGIAONHANID).FirstOrDefault();
                if (oIT.MA == ENUM_TRUONGHOP_GIAONHAN.KHONGTHUOC_THAMQUYEN_XETXU)
                {
                    if (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM)
                    {
                        oDon.TOAPHUCTHAMID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        //anhvh add 26/06/2020
                        //GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        //GD.GAIDOAN_INSERT_UPDATE("8", DonID, 3, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
                    }
                    else
                    {
                        //oDon.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        /*  Lê Nam
                            Chuyển án không thuộc thẩm quyền
                        */
                        string UserName = Session[ENUM_SESSION.SESSION_USERNAME] + "", LoaiVuViec = ENUM_LOAIVUVIEC.BPXLHC, MaToaAn = Session[ENUM_SESSION.SESSION_MADONVI] + "";
                        decimal ToaAnNhan = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
                                DonID_New = Action_ChuyenAn_KhongThuoc_ThamQuyen(DonID, LoaiVuViec, ToaAnNhan, MaToaAn, UserName);

                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        
                        // GD.GAIDOAN_INSERT_UPDATE("8", DonID_New, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                        GD.GAIDOAN_INSERT_UPDATE_V2("8", DonID_New, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                    }
                }
                else if (oIT.MA == ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM ||
                         oIT.MA == ENUM_TRUONGHOP_GIAONHAN.HUYQD_CHUYENHOSO)
                {
                    if (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                    {
                        //oDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                        //dt.SaveChanges();
                        XLHC_CHUYEN_NHAN_AN_BL _caBL = new XLHC_CHUYEN_NHAN_AN_BL();
                        decimal donIdOld = _caBL.getDonIdOld(oDon.ID);
                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        XLHC_DON oDonOld = dt.XLHC_DON.Where(x => x.ID == donIdOld).FirstOrDefault();
                        oDonOld.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                        dt.SaveChanges();
                        // GD.GAIDOAN_INSERT_UPDATE("8", donIdOld, ENUM_GIAIDOANVUAN.SOTHAM,
                        //     Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                        
                        GD.GAIDOAN_INSERT_UPDATE_V2("8", donIdOld, ENUM_GIAIDOANVUAN.SOTHAM,
                            Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);

                        #region toancau - anhnt update lại kết quả kháng cáo/kháng nghị

                        List<XLHC_SOTHAM_KHANGCAO> khangCaos = dt.XLHC_SOTHAM_KHANGCAO
                            .Where(x => x.DONID == donIdOld && (x.GQ_ISCHAPNHAN == null || x.GQ_ISCHAPNHAN == 1))
                            .ToList();
                        if (khangCaos != null && khangCaos.Count > 0)
                        {
                            foreach (XLHC_SOTHAM_KHANGCAO kc in khangCaos)
                            {
                                kc.GQ_TINHTRANG = 3; // đã giải quyết
                                dt.SaveChanges();
                            }
                        }

                        #endregion toancau - anhnt update lại kết quả kháng cáo/kháng nghị
                    }
                    else
                    {
                        XLHC_DON oDON_new = new XLHC_DON();
                        oDON_new.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        oDON_new.MAVUVIEC = oDon.MAVUVIEC;
                        oDON_new.TENVUVIEC = oDon.TENVUVIEC;
                        oDON_new.SOTHUTU = oDon.SOTHUTU;

                        // oDON_new.HINHTHUCNHANDON = oT.TRUONGHOPGIAONHANID;

                        oDON_new.HINHTHUCNHANDON = oDon.HINHTHUCNHANDON;
                        oDON_new.QUANHEPHAPLUATID = oDon.QUANHEPHAPLUATID;
                        oDON_new.CQDN_TEN = oDon.CQDN_TEN;
                        oDON_new.CQDN_DIACHICHITIET = oDon.CQDN_DIACHICHITIET;
                        oDON_new.CQDN_DIACHIID = oDon.CQDN_DIACHIID;
                        oDON_new.CQDN_EMAIL = oDon.CQDN_EMAIL;
                        oDON_new.CQDN_DIENTHOAI = oDon.CQDN_DIENTHOAI;
                        oDON_new.CQDN_FAX = oDon.CQDN_FAX;
                        oDON_new.CQDN_NGUOIDAIDIEN = oDon.CQDN_NGUOIDAIDIEN;
                        oDON_new.CQDN_CHUCVU = oDon.CQDN_CHUCVU;
                        oDON_new.QHPLTKID = oDon.QHPLTKID;
                        oDON_new.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                        oDON_new.QUANHEPHAPLUATID = oDon.QUANHEPHAPLUATID;
                        
                        oDON_new.NGAYVIETDON = oDon.NGAYVIETDON;
                        oDON_new.NGAYNHANDON = oDon.NGAYNHANDON;
                        oDON_new.LOAIQUANHE = oDon.LOAIQUANHE;
                        oDON_new.CANBONHANDONID = oDon.CANBONHANDONID;
                        oDON_new.THAMPHANKYNHANDON = oDon.THAMPHANKYNHANDON;
                        oDON_new.LOAIDON = oDon.LOAIDON;
                        oDON_new.TRANGTHAI = oDon.TRANGTHAI;
                        oDON_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oDON_new.NGAYTAO = DateTime.Now;
                        XLHC_DON_BL dsBL = new XLHC_DON_BL();
                        oDON_new.TT = dsBL.GETNEWTT((decimal)oDON_new.TOAANID);

                        oDON_new.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                        oDON_new.NOIDUNGKHOIKIEN = oDon.NOIDUNGKHOIKIEN;
                        oDON_new.TOAPHUCTHAMID = oDon.TOAPHUCTHAMID;
                        oDON_new.QHPLTKID = oDon.QHPLTKID;
                        oDON_new.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                        oDON_new.QUANHEPHAPLUAT_NAME = oDon.QUANHEPHAPLUAT_NAME;
                        //oDON_new.TENVUVIEC_PT = oDon.TENVUVIEC_PT;
                        oDON_new.TOA_GIAIQUYET_ID = oDon.TOA_GIAIQUYET_ID; // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                        //oDON_new.TOA_PHUCTHAM_GIAIQUYET_ID = oDON_new.TOAPHUCTHAMID; // VNPT- Đinh Hoàng Sơn - thêm TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                        dt.XLHC_DON.Add(oDON_new);
                        dt.SaveChanges();

                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        // GD.GAIDOAN_INSERT_UPDATE("8", oDON_new.ID, 2,
                        //     Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                        
                        GD.GAIDOAN_INSERT_UPDATE_V2("8", oDON_new.ID, 2,
                            Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);

                        List<XLHC_DUONGSU> lst = dt.XLHC_DUONGSU.Where(x => x.DONID == DonID).ToList();
                        
                        foreach (XLHC_DUONGSU vDuongsu_old in lst)
                        {
                                XLHC_DUONGSU vDuongsu_new = new XLHC_DUONGSU();
                                vDuongsu_new.DONID = oDON_new.ID;
                                vDuongsu_new.MABICAN = vDuongsu_old.MABICAN;
                                vDuongsu_new.BICANDAUVU = vDuongsu_old.BICANDAUVU;
                                vDuongsu_new.HOTEN = vDuongsu_old.HOTEN;
                                vDuongsu_new.TENKHAC = vDuongsu_old.TENKHAC;
                                vDuongsu_new.NGAYTHAMGIA = vDuongsu_old.NGAYTHAMGIA;
                                vDuongsu_new.SOCMND = vDuongsu_old.SOCMND;
                                vDuongsu_new.QUOCTICHID = vDuongsu_old.QUOCTICHID;
                                vDuongsu_new.TAMTRU = vDuongsu_old.TAMTRU;
                                vDuongsu_new.TAMTRUCHITIET = vDuongsu_old.TAMTRUCHITIET;
                                vDuongsu_new.HKTT = vDuongsu_old.HKTT;
                                vDuongsu_new.KHTTCHITIET = vDuongsu_old.KHTTCHITIET;
                                vDuongsu_new.NGAYSINH = vDuongsu_old.NGAYSINH;
                                vDuongsu_new.THANGSINH = vDuongsu_old.THANGSINH;
                                vDuongsu_new.NAMSINH = vDuongsu_old.NAMSINH;
                                vDuongsu_new.GIOITINH = vDuongsu_old.GIOITINH;
                                vDuongsu_new.TRINHDOVANHOAID = vDuongsu_old.TRINHDOVANHOAID;
                                vDuongsu_new.NGHENGHIEPID = vDuongsu_old.NGHENGHIEPID;
                                vDuongsu_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                vDuongsu_new.NGAYTAO = DateTime.Now;
                                vDuongsu_new.DANTOCID = vDuongsu_old.DANTOCID;
                                vDuongsu_new.TONGIAOID = vDuongsu_old.TONGIAOID;
                                vDuongsu_new.HOTENBO = vDuongsu_old.HOTENBO;
                                vDuongsu_new.HOTENME = vDuongsu_old.HOTENME;
                                vDuongsu_new.NAMSINHBO = vDuongsu_old.NAMSINHBO;
                                vDuongsu_new.NAMSINHME = vDuongsu_old.NAMSINHME;
                                vDuongsu_new.NGHIENHUT = vDuongsu_old.NGHIENHUT;
                                vDuongsu_new.TAIPHAM = vDuongsu_old.TAIPHAM;
                                vDuongsu_new.TIENAN = vDuongsu_old.TIENAN;
                                vDuongsu_new.TIENSU = vDuongsu_old.TIENSU;
                                vDuongsu_new.HKTTTINHID = vDuongsu_old.HKTTTINHID;
                                vDuongsu_new.TAMTRUTINHID = vDuongsu_old.TAMTRUTINHID;
                                vDuongsu_new.TREMOCOI = vDuongsu_old.TREMOCOI;
                                vDuongsu_new.TUOI = vDuongsu_old.TUOI;
                                vDuongsu_new.BOMELYHON = vDuongsu_old.BOMELYHON;
                                vDuongsu_new.ID_DUONGSU_TACC = vDuongsu_old.ID_DUONGSU_TACC;
                                vDuongsu_new.TREBOHOC = vDuongsu_old.TREBOHOC;
                                vDuongsu_new.TRELANGTHANG = vDuongsu_old.TRELANGTHANG;
                                vDuongsu_new.CONGUOIXUIGIUC = vDuongsu_old.CONGUOIXUIGIUC;
                                vDuongsu_new.CHUCVUDANGID = vDuongsu_old.CHUCVUDANGID;
                                vDuongsu_new.CHUCVUCHINHQUYENID = vDuongsu_old.CHUCVUCHINHQUYENID;
                                vDuongsu_new.TINHTRANGGIAMGIUID = vDuongsu_old.TINHTRANGGIAMGIUID;
                                vDuongsu_new.ISTREVITHANHNIEN = vDuongsu_old.ISTREVITHANHNIEN;
                                vDuongsu_new.LOAIDOITUONG = vDuongsu_old.LOAIDOITUONG;
                                vDuongsu_new.SODINHDANHCANHAN = vDuongsu_old.SODINHDANHCANHAN;
                                vDuongsu_new.HOCHIEU = vDuongsu_old.HOCHIEU;

                                dt.XLHC_DUONGSU.Add(vDuongsu_new);
                                dt.SaveChanges();
                        }
                        
                        //Ban giao tai lieu - Màn giao nhận tài liệu chứng cứ
                        List<XLHC_DON_TAILIEU> lstTaiLieu = dt.XLHC_DON_TAILIEU.Where(x => x.DONID == DonID).ToList<XLHC_DON_TAILIEU>();
                        foreach (XLHC_DON_TAILIEU vdonFile_old in lstTaiLieu)
                        {
                            XLHC_DON_TAILIEU donFile_new = new XLHC_DON_TAILIEU();
                            donFile_new.DONID = oDON_new.ID;
                            donFile_new.TENTAILIEU = vdonFile_old.TENTAILIEU;
                            donFile_new.TENFILE = vdonFile_old.TENFILE;
                            donFile_new.LOAIFILE = vdonFile_old.LOAIFILE;
                            donFile_new.NOIDUNG = vdonFile_old.NOIDUNG;
                            donFile_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            donFile_new.NGAYTAO = DateTime.Now;
                            donFile_new.BANGIAOID = vdonFile_old.BANGIAOID;
                            donFile_new.NGAYBANGIAO = vdonFile_old.NGAYBANGIAO;
                            donFile_new.NGUOIBANGIAO = vdonFile_old.NGUOIBANGIAO;
                            donFile_new.NGUOIBANGIAO_NEW = vdonFile_old.NGUOIBANGIAO_NEW;
                            donFile_new.LOAIDOITUONG = vdonFile_old.LOAIDOITUONG;
                            donFile_new.NGUOINHANID = vdonFile_old.NGUOINHANID;
                            donFile_new.NGUONBANGIAO = vdonFile_old.NGUONBANGIAO;
                            donFile_new.TOA_GIAIQUYET_ID = vdonFile_old.TOA_GIAIQUYET_ID; // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                            dt.XLHC_DON_TAILIEU.Add(donFile_new);
                            dt.SaveChanges();
                        }
                        
                        //Màn người tham gia tố tụng
                        List<XLHC_DON_THAMGIATOTUNG> listToTung =
                            dt.XLHC_DON_THAMGIATOTUNG.Where(x => x.DONID == DonID).ToList();
                        
                        foreach (var thamgiatotungOld in listToTung)
                        {
                            XLHC_DON_THAMGIATOTUNG thamgiatotungNew = new XLHC_DON_THAMGIATOTUNG();
                            thamgiatotungNew.DONID = oDON_new.ID;
                            thamgiatotungNew.HOTEN = thamgiatotungOld.HOTEN;
                            thamgiatotungNew.TAMTRUID = thamgiatotungOld.TAMTRUID;
                            thamgiatotungNew.TAMTRUCHITIET = thamgiatotungOld.TAMTRUCHITIET;
                            thamgiatotungNew.HKTTID = thamgiatotungOld.HKTTID;
                            thamgiatotungNew.HKTTCHITIET = thamgiatotungOld.HKTTCHITIET;
                            thamgiatotungNew.NGAYSINH = thamgiatotungOld.NGAYSINH;
                            thamgiatotungNew.THANGSINH = thamgiatotungOld.THANGSINH;
                            thamgiatotungNew.NAMSINH = thamgiatotungOld.NAMSINH;
                            thamgiatotungNew.GIOITINH = thamgiatotungOld.GIOITINH;
                            thamgiatotungNew.TUCACHTGTTID = thamgiatotungOld.TUCACHTGTTID;
                            thamgiatotungNew.NGUOIDAIDIEN = thamgiatotungOld.NGUOIDAIDIEN;
                            thamgiatotungNew.CHUCVU = thamgiatotungOld.CHUCVU;
                            thamgiatotungNew.NGAYTHAMGIA = thamgiatotungOld.NGAYTHAMGIA;
                            thamgiatotungNew.NGAYKETTHUC = thamgiatotungOld.NGAYKETTHUC;
                            thamgiatotungNew.NGAYTAO = DateTime.Now;
                            thamgiatotungNew.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            thamgiatotungNew.EMAIL = thamgiatotungOld.EMAIL;
                            thamgiatotungNew.DIENTHOAI = thamgiatotungOld.DIENTHOAI;
                            thamgiatotungNew.FAX = thamgiatotungOld.FAX;
                            thamgiatotungNew.HKTTTINHID = thamgiatotungOld.HKTTTINHID;
                            thamgiatotungNew.TAMTRUTINHID = thamgiatotungOld.TAMTRUTINHID;
                            thamgiatotungNew.ID_DUONGSU_TACC = thamgiatotungOld.ID_DUONGSU_TACC;
                            thamgiatotungNew.TOA_GIAIQUYET_ID = thamgiatotungOld.TOA_GIAIQUYET_ID; // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                            dt.XLHC_DON_THAMGIATOTUNG.Add(thamgiatotungNew); // VNPT- Đinh Hoàng Sơn - chỉnh code thêm người tham gia tố tụng - 17-9-2025 08:00
                            dt.SaveChanges(); // VNPT- Đinh Hoàng Sơn - chỉnh code thêm người tham gia tố tụng - 17-9-2025 08:00
                        }

                        //// Phan cong Tham phan - Màn thẩm phán xử lý hồ sơ
                        List<XLHC_DON_THAMPHAN> lstThamPhan = dt.XLHC_DON_THAMPHAN
                            .Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON)
                            .ToList<XLHC_DON_THAMPHAN>();
                        foreach (XLHC_DON_THAMPHAN vThamphan_old in lstThamPhan)
                        {
                            XLHC_DON_THAMPHAN vThamphan_new = new XLHC_DON_THAMPHAN();
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
                            vThamphan_new.TOA_GIAIQUYET_ID = vThamphan_old.TOA_GIAIQUYET_ID; // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                            dt.XLHC_DON_THAMPHAN.Add(vThamphan_new);
                            dt.SaveChanges();
                        }

                        ////Xu ly don - Màn xử lý hồ sơ
                        List<XLHC_DON_XULY> lstXulyDon =
                            dt.XLHC_DON_XULY.Where(x => x.DONID == DonID).ToList<XLHC_DON_XULY>();
                        foreach (XLHC_DON_XULY vXulyDon_old in lstXulyDon)
                        {
                            XLHC_DON_XULY vXulyDon_new = new XLHC_DON_XULY();
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
                            vXulyDon_new.TOAANID = vXulyDon_old.TOAANID;
                            vXulyDon_new.TOA_GIAIQUYET_ID = vXulyDon_old.TOA_GIAIQUYET_ID; // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                            dt.XLHC_DON_XULY.Add(vXulyDon_new);
                            dt.SaveChanges();
                        }

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
                        if (LoaiAn == ENUM_LOAIAN.BPXLHC)
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
                    string UserName = Session[ENUM_SESSION.SESSION_USERNAME] + "", LoaiVuViec = ENUM_LOAIVUVIEC.BPXLHC, MaToaAn = Session[ENUM_SESSION.SESSION_MADONVI] + "";
                    decimal ToaAnNhan = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
                            DonID_New = Action_ChuyenAn_KhongThuoc_ThamQuyen(DonID, LoaiVuViec, ToaAnNhan, MaToaAn, UserName);

                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    // GD.GAIDOAN_INSERT_UPDATE("8", DonID_New, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                    
                    GD.GAIDOAN_INSERT_UPDATE_V2("8", DonID_New, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);

                }
                else
                {
                    oDon.TOAPHUCTHAMID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    XLHC_SOTHAM_BL xLHC_SOTHAM_BL = new XLHC_SOTHAM_BL();
                    XLHC_CHUYEN_NHAN_AN_BL _chuyenNhanAnBl = new XLHC_CHUYEN_NHAN_AN_BL();

                    if (_chuyenNhanAnBl.CheckCoKcKnTamDinhChi(DonID))
                    {
                        oDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                        #region duyhh Kiểm tra xem có phải kháng cáo kháng nghị quyết định khác
                        #region tạo đơn mới cho án phúc thẩm kc/kn tạm đình chỉ
                        XLHC_DON oDON_new = new XLHC_DON();
                        oDON_new.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        oDON_new.MAVUVIEC = oDon.MAVUVIEC;
                        oDON_new.TENVUVIEC = oDon.TENVUVIEC;
                        oDON_new.SOTHUTU = oDon.SOTHUTU;

                        oDON_new.HINHTHUCNHANDON = oT.TRUONGHOPGIAONHANID;

                        oDON_new.QUANHEPHAPLUATID = oDon.QUANHEPHAPLUATID;
                        oDON_new.CQDN_TEN = oDon.CQDN_TEN;
                        oDON_new.CQDN_DIACHICHITIET = oDon.CQDN_DIACHICHITIET;
                        oDON_new.CQDN_DIACHIID = oDon.CQDN_DIACHIID;
                        oDON_new.CQDN_EMAIL = oDon.CQDN_EMAIL;
                        oDON_new.CQDN_DIENTHOAI = oDon.CQDN_DIENTHOAI;
                        oDON_new.CQDN_FAX = oDon.CQDN_FAX;
                        oDON_new.CQDN_NGUOIDAIDIEN = oDon.CQDN_NGUOIDAIDIEN;
                        oDON_new.CQDN_CHUCVU = oDon.CQDN_CHUCVU;
                        oDON_new.QHPLTKID = oDon.QHPLTKID;
                        oDON_new.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                        oDON_new.QUANHEPHAPLUATID = oDon.QUANHEPHAPLUATID;

                        oDON_new.NGAYVIETDON = oDon.NGAYVIETDON;
                        oDON_new.NGAYNHANDON = oDon.NGAYNHANDON;
                        oDON_new.LOAIQUANHE = oDon.LOAIQUANHE;
                        oDON_new.CANBONHANDONID = oDon.CANBONHANDONID;
                        oDON_new.THAMPHANKYNHANDON = oDon.THAMPHANKYNHANDON;
                        oDON_new.LOAIDON = oDon.LOAIDON;
                        oDON_new.TRANGTHAI = oDon.TRANGTHAI;
                        oDON_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oDON_new.NGAYTAO = DateTime.Now;

                        XLHC_DON_BL dsBL = new XLHC_DON_BL();
                        oDON_new.TT = dsBL.GETNEWTT((decimal)oDON_new.TOAANID);

                        oDON_new.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM_QDK;
                        oDON_new.NOIDUNGKHOIKIEN = oDon.NOIDUNGKHOIKIEN;
                        oDON_new.TOAPHUCTHAMID = oDon.TOAPHUCTHAMID;
                        oDON_new.QHPLTKID = oDon.QHPLTKID;
                        oDON_new.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                        oDON_new.QUANHEPHAPLUAT_NAME = oDon.QUANHEPHAPLUAT_NAME;
                        oDON_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(oDON_new.TOAANID); // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                        oDON_new.TOA_PHUCTHAM_GIAIQUYET_ID = oDON_new.TOAPHUCTHAMID; // VNPT- Đinh Hoàng Sơn - thêm TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                        dt.XLHC_DON.Add(oDON_new);
                        dt.SaveChanges();

                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        GD.GAIDOAN_INSERT_UPDATE_V2("8", oDON_new.ID, ENUM_GIAIDOANVUAN.PHUCTHAM_QDK, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), oDon.TOAPHUCTHAMID.Value, 0, 0, 0);

                        List<XLHC_DUONGSU> lst = dt.XLHC_DUONGSU.Where(x => x.DONID == DonID).ToList();

                        foreach (XLHC_DUONGSU vDuongsu_old in lst)
                        {
                            XLHC_DUONGSU vDuongsu_new = new XLHC_DUONGSU();
                            vDuongsu_new.DONID = oDON_new.ID;
                            vDuongsu_new.MABICAN = vDuongsu_old.MABICAN;
                            vDuongsu_new.BICANDAUVU = vDuongsu_old.BICANDAUVU;
                            vDuongsu_new.HOTEN = vDuongsu_old.HOTEN;
                            vDuongsu_new.TENKHAC = vDuongsu_old.TENKHAC;
                            vDuongsu_new.NGAYTHAMGIA = vDuongsu_old.NGAYTHAMGIA;
                            vDuongsu_new.SOCMND = vDuongsu_old.SOCMND;
                            vDuongsu_new.QUOCTICHID = vDuongsu_old.QUOCTICHID;
                            vDuongsu_new.TAMTRU = vDuongsu_old.TAMTRU;
                            vDuongsu_new.TAMTRUCHITIET = vDuongsu_old.TAMTRUCHITIET;
                            vDuongsu_new.HKTT = vDuongsu_old.HKTT;
                            vDuongsu_new.KHTTCHITIET = vDuongsu_old.KHTTCHITIET;
                            vDuongsu_new.NGAYSINH = vDuongsu_old.NGAYSINH;
                            vDuongsu_new.THANGSINH = vDuongsu_old.THANGSINH;
                            vDuongsu_new.NAMSINH = vDuongsu_old.NAMSINH;
                            vDuongsu_new.GIOITINH = vDuongsu_old.GIOITINH;
                            vDuongsu_new.TRINHDOVANHOAID = vDuongsu_old.TRINHDOVANHOAID;
                            vDuongsu_new.NGHENGHIEPID = vDuongsu_old.NGHENGHIEPID;
                            vDuongsu_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            vDuongsu_new.NGAYTAO = DateTime.Now;
                            vDuongsu_new.DANTOCID = vDuongsu_old.DANTOCID;
                            vDuongsu_new.TONGIAOID = vDuongsu_old.TONGIAOID;
                            vDuongsu_new.HOTENBO = vDuongsu_old.HOTENBO;
                            vDuongsu_new.HOTENME = vDuongsu_old.HOTENME;
                            vDuongsu_new.NAMSINHBO = vDuongsu_old.NAMSINHBO;
                            vDuongsu_new.NAMSINHME = vDuongsu_old.NAMSINHME;
                            vDuongsu_new.NGHIENHUT = vDuongsu_old.NGHIENHUT;
                            vDuongsu_new.TAIPHAM = vDuongsu_old.TAIPHAM;
                            vDuongsu_new.TIENAN = vDuongsu_old.TIENAN;
                            vDuongsu_new.TIENSU = vDuongsu_old.TIENSU;
                            vDuongsu_new.HKTTTINHID = vDuongsu_old.HKTTTINHID;
                            vDuongsu_new.TAMTRUTINHID = vDuongsu_old.TAMTRUTINHID;
                            vDuongsu_new.TREMOCOI = vDuongsu_old.TREMOCOI;
                            vDuongsu_new.TUOI = vDuongsu_old.TUOI;
                            vDuongsu_new.BOMELYHON = vDuongsu_old.BOMELYHON;
                            vDuongsu_new.ID_DUONGSU_TACC = vDuongsu_old.ID_DUONGSU_TACC;
                            vDuongsu_new.TREBOHOC = vDuongsu_old.TREBOHOC;
                            vDuongsu_new.TRELANGTHANG = vDuongsu_old.TRELANGTHANG;
                            vDuongsu_new.CONGUOIXUIGIUC = vDuongsu_old.CONGUOIXUIGIUC;
                            vDuongsu_new.CHUCVUDANGID = vDuongsu_old.CHUCVUDANGID;
                            vDuongsu_new.CHUCVUCHINHQUYENID = vDuongsu_old.CHUCVUCHINHQUYENID;
                            vDuongsu_new.TINHTRANGGIAMGIUID = vDuongsu_old.TINHTRANGGIAMGIUID;
                            vDuongsu_new.ISTREVITHANHNIEN = vDuongsu_old.ISTREVITHANHNIEN;
                            vDuongsu_new.LOAIDOITUONG = vDuongsu_old.LOAIDOITUONG;
                            vDuongsu_new.SODINHDANHCANHAN = vDuongsu_old.SODINHDANHCANHAN;
                            vDuongsu_new.HOCHIEU = vDuongsu_old.HOCHIEU;

                            dt.XLHC_DUONGSU.Add(vDuongsu_new);
                            dt.SaveChanges();
                        }

                        //Ban giao tai lieu - Màn giao nhận tài liệu chứng cứ
                        List<XLHC_DON_TAILIEU> lstTaiLieu = dt.XLHC_DON_TAILIEU.Where(x => x.DONID == DonID).ToList<XLHC_DON_TAILIEU>();
                        foreach (XLHC_DON_TAILIEU vdonFile_old in lstTaiLieu)
                        {
                            XLHC_DON_TAILIEU donFile_new = new XLHC_DON_TAILIEU();
                            donFile_new.DONID = oDON_new.ID;
                            donFile_new.TENTAILIEU = vdonFile_old.TENTAILIEU;
                            donFile_new.TENFILE = vdonFile_old.TENFILE;
                            donFile_new.LOAIFILE = vdonFile_old.LOAIFILE;
                            donFile_new.NOIDUNG = vdonFile_old.NOIDUNG;
                            donFile_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            donFile_new.NGAYTAO = DateTime.Now;
                            donFile_new.BANGIAOID = vdonFile_old.BANGIAOID;
                            donFile_new.NGAYBANGIAO = vdonFile_old.NGAYBANGIAO;
                            donFile_new.NGUOIBANGIAO = vdonFile_old.NGUOIBANGIAO;
                            donFile_new.NGUOIBANGIAO_NEW = vdonFile_old.NGUOIBANGIAO_NEW;
                            donFile_new.LOAIDOITUONG = vdonFile_old.LOAIDOITUONG;
                            donFile_new.NGUOINHANID = vdonFile_old.NGUOINHANID;
                            donFile_new.NGUONBANGIAO = vdonFile_old.NGUONBANGIAO;
                            donFile_new.TOA_GIAIQUYET_ID = vdonFile_old.TOA_GIAIQUYET_ID; // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                            dt.XLHC_DON_TAILIEU.Add(donFile_new);
                            dt.SaveChanges();
                        }

                        //Màn người tham gia tố tụng
                        List<XLHC_DON_THAMGIATOTUNG> listToTung =
                            dt.XLHC_DON_THAMGIATOTUNG.Where(x => x.DONID == DonID).ToList();

                        foreach (var thamgiatotungOld in listToTung)
                        {
                            XLHC_DON_THAMGIATOTUNG thamgiatotungNew = new XLHC_DON_THAMGIATOTUNG();
                            thamgiatotungNew.DONID = oDON_new.ID;
                            thamgiatotungNew.HOTEN = thamgiatotungOld.HOTEN;
                            thamgiatotungNew.TAMTRUID = thamgiatotungOld.TAMTRUID;
                            thamgiatotungNew.TAMTRUCHITIET = thamgiatotungOld.TAMTRUCHITIET;
                            thamgiatotungNew.HKTTID = thamgiatotungOld.HKTTID;
                            thamgiatotungNew.HKTTCHITIET = thamgiatotungOld.HKTTCHITIET;
                            thamgiatotungNew.NGAYSINH = thamgiatotungOld.NGAYSINH;
                            thamgiatotungNew.THANGSINH = thamgiatotungOld.THANGSINH;
                            thamgiatotungNew.NAMSINH = thamgiatotungOld.NAMSINH;
                            thamgiatotungNew.GIOITINH = thamgiatotungOld.GIOITINH;
                            thamgiatotungNew.TUCACHTGTTID = thamgiatotungOld.TUCACHTGTTID;
                            thamgiatotungNew.NGUOIDAIDIEN = thamgiatotungOld.NGUOIDAIDIEN;
                            thamgiatotungNew.CHUCVU = thamgiatotungOld.CHUCVU;
                            thamgiatotungNew.NGAYTHAMGIA = thamgiatotungOld.NGAYTHAMGIA;
                            thamgiatotungNew.NGAYKETTHUC = thamgiatotungOld.NGAYKETTHUC;
                            thamgiatotungNew.NGAYTAO = DateTime.Now;
                            thamgiatotungNew.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            thamgiatotungNew.EMAIL = thamgiatotungOld.EMAIL;
                            thamgiatotungNew.DIENTHOAI = thamgiatotungOld.DIENTHOAI;
                            thamgiatotungNew.FAX = thamgiatotungOld.FAX;
                            thamgiatotungNew.HKTTTINHID = thamgiatotungOld.HKTTTINHID;
                            thamgiatotungNew.TAMTRUTINHID = thamgiatotungOld.TAMTRUTINHID;
                            thamgiatotungNew.ID_DUONGSU_TACC = thamgiatotungOld.ID_DUONGSU_TACC;
                            thamgiatotungNew.TOA_GIAIQUYET_ID = thamgiatotungOld.TOA_GIAIQUYET_ID; // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                            dt.XLHC_DON_THAMGIATOTUNG.Add(thamgiatotungNew); // VNPT- Đinh Hoàng Sơn - chỉnh code thêm người tham gia tố tụng - 17-9-2025 08:00
                            dt.SaveChanges(); // VNPT- Đinh Hoàng Sơn - chỉnh code thêm người tham gia tố tụng - 17-9-2025 08:00
                        }

                        //// Phan cong Tham phan - Màn thẩm phán xử lý hồ sơ
                        List<XLHC_DON_THAMPHAN> lstThamPhan = dt.XLHC_DON_THAMPHAN
                            .Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON)
                            .ToList<XLHC_DON_THAMPHAN>();
                        foreach (XLHC_DON_THAMPHAN vThamphan_old in lstThamPhan)
                        {
                            XLHC_DON_THAMPHAN vThamphan_new = new XLHC_DON_THAMPHAN();
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
                            vThamphan_new.TOA_GIAIQUYET_ID = vThamphan_old.TOA_GIAIQUYET_ID; // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                            dt.XLHC_DON_THAMPHAN.Add(vThamphan_new);
                            dt.SaveChanges();
                        }

                        ////Xu ly don - Màn xử lý hồ sơ
                        List<XLHC_DON_XULY> lstXulyDon =
                            dt.XLHC_DON_XULY.Where(x => x.DONID == DonID).ToList<XLHC_DON_XULY>();
                        foreach (XLHC_DON_XULY vXulyDon_old in lstXulyDon)
                        {
                            XLHC_DON_XULY vXulyDon_new = new XLHC_DON_XULY();
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
                            vXulyDon_new.TOAANID = vXulyDon_old.TOAANID;
                            vXulyDon_new.TOA_GIAIQUYET_ID = vXulyDon_old.TOA_GIAIQUYET_ID; // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                            dt.XLHC_DON_XULY.Add(vXulyDon_new);
                            dt.SaveChanges();
                        }

                        oT.MAP_VUANID_NEW = oDON_new.ID;
                        dt.SaveChanges();
                        #endregion tạo đơn mới cho án phúc thẩm kc/kn tạm đình chỉ
                        #endregion duyhh Kiểm tra xem có phải kháng cáo kháng nghị quyết định khác
                    }
                    else
                    {

                        oDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                        dt.SaveChanges();
                        //anhvh add 26/06/2020
                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        // GD.GAIDOAN_INSERT_UPDATE("8", DonID, 3, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);

                        GD.GAIDOAN_INSERT_UPDATE_V2("8", DonID, oDon.MAGIAIDOAN.Value, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
                    }

                }
                oT.TRANGTHAI = 1;// 0: Chuyển chờ nhận, 1: Nhận
                oT.NGAYGIAO = (String.IsNullOrEmpty(txtN_Ngaygiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtN_Ngaygiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.NGAYNHAN = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.NGUOINHANID = Convert.ToDecimal(ddlN_Nguoinhan.SelectedValue);
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
                    XLHC_DUONGSU DuongSu = dt.XLHC_DUONGSU.Where(x => x.DONID == DonID && x.ID_DUONGSU_TACC == item.Guid).FirstOrDefault();
                    if (DuongSu == null)
                    {
                        IsNew = true;
                        DuongSu = new XLHC_DUONGSU();
                    }
                    DuongSu.HOTEN = item.TENDUONGSU;
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
                    DuongSu.TAMTRU = item.MA_HUYEN + "" == "" ? 0 : Convert.ToDecimal(item.MA_HUYEN);
                    DuongSu.TAMTRUCHITIET = item.DIACHICHITIET;
                    switch (item.LOAIDUONGSU + "")
                    {
                        case "CANHAN":
                            DuongSu.LOAIDOITUONG = 1;
                            break;
                        case "COQUAN":
                            DuongSu.LOAIDOITUONG = 2;
                            break;
                        case "TOCHUC":
                            DuongSu.LOAIDOITUONG = 3;
                            break;
                    }
                    if (IsNew)
                    {
                        dt.XLHC_DUONGSU.Add(DuongSu);
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
                    XLHC_DON_THAMGIATOTUNG NguoiTGTT = dt.XLHC_DON_THAMGIATOTUNG.Where(x => x.DONID == DonID && x.ID_DUONGSU_TACC == item.Guid).FirstOrDefault();
                    if (NguoiTGTT != null)
                    {
                        IsNew = true;
                        NguoiTGTT = new XLHC_DON_THAMGIATOTUNG();
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
                        NguoiTGTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                        dt.XLHC_DON_THAMGIATOTUNG.Add(NguoiTGTT);
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
                XLHC_SOTHAM_THULY STThuLy = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == DonID && x.SOTHULY == ThuLy.SOTHULY.ToString()).FirstOrDefault();
                if (STThuLy != null)
                {
                    IsNew = true;
                    STThuLy = new XLHC_SOTHAM_THULY();
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
                    dt.XLHC_SOTHAM_THULY.Add(STThuLy);
                }
                dt.SaveChanges();
            }
            else
            {
                // Update thụ lý phúc thẩm
                bool IsNew = false;
                XLHC_PHUCTHAM_THULY PTThuLy = dt.XLHC_PHUCTHAM_THULY.Where(x => x.DONID == DonID && x.SOTHULY == ThuLy.SOTHULY.ToString()).FirstOrDefault();
                if (PTThuLy != null)
                {
                    IsNew = true;
                    PTThuLy = new XLHC_PHUCTHAM_THULY();
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
                    dt.XLHC_PHUCTHAM_THULY.Add(PTThuLy);
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
                        XLHC_SOTHAM_HDXX Hdxx = dt.XLHC_SOTHAM_HDXX.Where(x => x.DONID == DonID && x.CANBOID == CanBoID).FirstOrDefault();
                        if (Hdxx == null)
                        {
                            IsNew = true;
                            Hdxx = new XLHC_SOTHAM_HDXX();
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
                            Hdxx.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                            dt.XLHC_SOTHAM_HDXX.Add(Hdxx);
                        }
                    }
                    // Phúc thẩm
                    else
                    {
                        XLHC_PHUCTHAM_HDXX Hdxx = dt.XLHC_PHUCTHAM_HDXX.Where(x => x.DONID == DonID && x.CANBOID == CanBoID).FirstOrDefault();
                        if (Hdxx == null)
                        {
                            IsNew = true;
                            Hdxx = new XLHC_PHUCTHAM_HDXX();
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
                            Hdxx.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                            dt.XLHC_PHUCTHAM_HDXX.Add(Hdxx);
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
                        XLHC_SOTHAM_QUYETDINH QdVuAn = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.DONID == DonID && x.TOAANID == ToaAnID).FirstOrDefault();
                        if (QdVuAn == null)
                        {
                            IsNew = false;
                            QdVuAn = new XLHC_SOTHAM_QUYETDINH()
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
                            QdVuAn.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                            dt.XLHC_SOTHAM_QUYETDINH.Add(QdVuAn);
                        }
                        dt.SaveChanges();
                    }
                    // Phúc thẩm
                    else
                    {
                        XLHC_PHUCTHAM_QUYETDINH QdVuAn = dt.XLHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == DonID && x.TOAANID == ToaAnID).FirstOrDefault();
                        if (QdVuAn == null)
                        {
                            IsNew = false;
                            QdVuAn = new XLHC_PHUCTHAM_QUYETDINH()
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
                            dt.XLHC_PHUCTHAM_QUYETDINH.Add(QdVuAn);
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
                XLHC_SOTHAM_BANAN STBanAn = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == DonID && x.TOAANID == ToaAnID).FirstOrDefault();
                if (STBanAn == null)
                {
                    IsNew = true;
                    STBanAn = new XLHC_SOTHAM_BANAN();
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
                    STBanAn.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                    dt.XLHC_SOTHAM_BANAN.Add(STBanAn);
                }
                dt.SaveChanges();
            }
            // Phúc thẩm
            else
            {
                XLHC_PHUCTHAM_BANAN PTBanAn = dt.XLHC_PHUCTHAM_BANAN.Where(x => x.DONID == DonID && x.TOAANID == ToaAnID).FirstOrDefault();
                if (PTBanAn == null)
                {
                    IsNew = true;
                    PTBanAn = new XLHC_PHUCTHAM_BANAN();
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
                DM_KETQUA_PHUCTHAM KQPT = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ISXLHC == 1 && x.MA == bAn.KETQUA).FirstOrDefault();
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
                    PTBanAn.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); // VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                    dt.XLHC_PHUCTHAM_BANAN.Add(PTBanAn);
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
                    XLHC_DUONGSU DuongSu = dt.XLHC_DUONGSU.Where(x => x.DONID == DonID && x.ID_DUONGSU_TACC == Guid_NguoiKC).FirstOrDefault();
                    if (DuongSu != null)
                    {
                        NguoiKCID = DuongSu.ID;
                    }
                    XLHC_SOTHAM_KHANGCAO kc = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == DonID && x.DUONGSUID == NguoiKCID && x.TOAANRAQDID == ToaAnID).FirstOrDefault();
                    if (kc != null)
                    {
                        IsNew = true;
                        kc = new XLHC_SOTHAM_KHANGCAO();
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
                        dt.XLHC_SOTHAM_KHANGCAO.Add(kc);
                    }
                    dt.SaveChanges();
                    #endregion
                }
            }
        }
        #endregion
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

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ChuyenNhanID = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "HuyNhan":
                        HuyNhan(ChuyenNhanID);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdHuyNhan_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ChuyenNhanID = 0;
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        ChuyenNhanID = Convert.ToDecimal(chkChon.ToolTip);
                        break;
                    }
                }
                HuyNhan(ChuyenNhanID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_CVA_KHONG_THAM_QUYEN", parameters);
            decimal Result = 0;
            if (tbl.Rows.Count > 0)
                Result = Convert.ToDecimal(tbl.Rows[0]["ID"]);
            return Result;
        }

        private void HuyNhan(decimal ChuyenNhanID)
        {
            decimal DonID_New = 0;
            XLHC_DON_BL Bl = new XLHC_DON_BL();
            int LoaiVuViec = Convert.ToInt32(ENUM_LOAIVUVIEC.BPXLHC);
            XLHC_CHUYEN_NHAN_AN ObjChuyenAn = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.ID == ChuyenNhanID).FirstOrDefault();
            
            if (ObjChuyenAn != null)
            {
                if (ObjChuyenAn.MAP_VUANID_NEW.GetValueOrDefault(0) > 0)
                {
                    DonID_New = ObjChuyenAn.MAP_VUANID_NEW + "" == "" ? 0 : (decimal)ObjChuyenAn.MAP_VUANID_NEW;

                    // Xóa dữ liệu liên quan đến vụ việc đã nhận tại tòa nhận
                    // Đơn chưa được thụ lý mới được phép hủy nhận và xóa dữ liệu

                    bool IsThuLy = Bl.Check_ThuLy(DonID_New);
                    if (IsThuLy)
                    {
                        lbthongbao.Text = "Án đã được thụ lý. Không được phép hủy nhận án.";
                        return;
                    }

                    if (ObjChuyenAn != null)
                    {
                        ObjChuyenAn.MAP_VUANID_NEW = null;
                        ObjChuyenAn.TRANGTHAI = 0;
                        ObjChuyenAn.NGAYNHAN = null;
                        dt.SaveChanges();
                    }

                    //Luu thong tin ho so vu an khi xoa khi hủy nhận án
                    string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    XLHC_DON oDonNew = dt.XLHC_DON.Where(x => x.ID == DonID_New).FirstOrDefault();
                    var json = new JavaScriptSerializer().Serialize(oDonNew);
                    ADS_DON_BL oBL = new ADS_DON_BL();
                    if (oBL.HISTORY_ALLDATA_BY_VUANID(DonID_New, LoaiVuViec, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Nhân án Dan su ", "Xóa", json) == false)
                    {
                        return;
                    }
                    //Ket thuc


                    Bl.DELETE_ALLDATA_BY_VUANID(DonID_New.ToString());
                    GIAI_DOAN_BL gdbl = new GIAI_DOAN_BL();

                    // khi hủy nhận án update trạng thái xlhc_đơn
                    XLHC_DON oVuan = dt.XLHC_DON.Where(x => x.ID == ObjChuyenAn.VUANID).FirstOrDefault();
                    if (DonID_New > 0)
                    {
                        gdbl.GIAIDOAN_DELETES(LoaiVuViec.ToString(), DonID_New, Convert.ToDecimal(oVuan.MAGIAIDOAN));
                        if (oDonNew.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                            oVuan.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                        dt.SaveChanges();
                    }
                    else
                    {
                        gdbl.GIAIDOAN_DELETES(LoaiVuViec.ToString(), Convert.ToDecimal(ObjChuyenAn.VUANID), Convert.ToDecimal(oVuan.MAGIAIDOAN));

                        XLHC_DON_HOANMIEN_BL xLHC_DON_HOANMIEN_BL = new XLHC_DON_HOANMIEN_BL();
                        DataTable dataTable = xLHC_DON_HOANMIEN_BL.GET_XLHC_DON_GIAIDOAN_BY_DONID(ObjChuyenAn.VUANID);

                        if (dataTable != null && dataTable.Rows.Count > 0)
                        {
                            oVuan.MAGIAIDOAN = Convert.ToDecimal(dataTable.Rows[0]["MAGIAIDOAN"]);
                            oVuan.TOAPHUCTHAMID = null;
                            dt.SaveChanges();
                        }
                    }

                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    lbthongbao.Text = "Hủy nhận án thành công.";
                }
                else
                {
                    XLHC_DON oVuan = dt.XLHC_DON.Where(x => x.ID == ObjChuyenAn.VUANID).FirstOrDefault();
                    if (oVuan.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                    {
                        XLHC_CHUYEN_NHAN_AN_BL _chuyenNhanAnBl = new XLHC_CHUYEN_NHAN_AN_BL();
                        var oldVuAnId = _chuyenNhanAnBl.getDonIdOld(oVuan.ID);
                        //lay chuyen an tu st len pt tdc
                        XLHC_CHUYEN_NHAN_AN chuyenAnSTlenPTTDC = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == oVuan.ID).FirstOrDefault();
                        List<XLHC_SOTHAM_THULY> oThuLyST = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                        List<XLHC_SOTHAM_HDXX> oSTNguoiTienHanhToTung = dt.XLHC_SOTHAM_HDXX.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                        List<XLHC_DON_THAMPHAN> oThamPhanST = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                        List<XLHC_SOTHAM_BANAN> oBanAnST = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                        List<XLHC_SOTHAM_QUYETDINH> oQDST = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                        List<XLHC_SOTHAM_KHANGCAO> oKCST = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                        List<XLHC_SOTHAM_KHANGNGHI> oKNST = dt.XLHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();

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
                            XLHC_DON oVuAnOld = dt.XLHC_DON.Where(x => x.ID == oldVuAnId).FirstOrDefault();
                            XLHC_CHUYEN_NHAN_AN objChuyenAnLanCuoi = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == oldVuAnId && x.TOACHUYENID == oVuAnOld.TOAANID).OrderByDescending(x => x.ID).FirstOrDefault();
                            XLHC_CHUYEN_NHAN_AN objChuyenAnLanGanCuoi = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == oldVuAnId && x.TOACHUYENID == oVuAnOld.TOAANID && x.ID < objChuyenAnLanCuoi.ID).OrderByDescending(x => x.ID).FirstOrDefault();
                            if (objChuyenAnLanGanCuoi == null)
                            {
                                
                                List<XLHC_SOTHAM_KHANGCAO> khangCaos = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == oldVuAnId && x.GQ_TINHTRANG == 1).ToList();
                                if (khangCaos != null && khangCaos.Count > 0)
                                {
                                    foreach (XLHC_SOTHAM_KHANGCAO kc in khangCaos)
                                    {
                                        kc.GQ_TINHTRANG = 2;
                                        dt.SaveChanges();
                                    }
                                }
                              
                            }
                            else
                            {
                                
                                List<XLHC_SOTHAM_KHANGCAO> khangCaos = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == oldVuAnId && x.GQ_TINHTRANG == 1 && x.NGAYTAO >= objChuyenAnLanGanCuoi.NGAYTAO && x.NGAYTAO <= objChuyenAnLanCuoi.NGAYTAO).ToList();
                                if (khangCaos != null && khangCaos.Count > 0)
                                {
                                    foreach (XLHC_SOTHAM_KHANGCAO kc in khangCaos)
                                    {
                                        kc.GQ_TINHTRANG = 2;
                                        dt.SaveChanges();
                                    }
                                }
                            }
                            //ObjChuyenAn.NGUOITAO_PHUCTHAM = null;
                            //ObjChuyenAn.NGAYTAO_PHUCTHAM = null;
                            ObjChuyenAn.TRANGTHAI = 0;
                            ObjChuyenAn.NGAYNHAN = null;

                            if (oVuAnOld != null)
                                oVuAnOld.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;

                            dt.SaveChanges();
                        }
                    }
                    else
                    {
                        bool IsThuLy = Bl.Check_ThuLy(ObjChuyenAn.VUANID.Value);
                        if (!IsThuLy)
                        {
                            GIAI_DOAN_BL gdbl = new GIAI_DOAN_BL();
                            gdbl.GIAIDOAN_DELETES(LoaiVuViec.ToString(), Convert.ToDecimal(ObjChuyenAn.VUANID), Convert.ToDecimal(oVuan.MAGIAIDOAN));

                            ObjChuyenAn.TRANGTHAI = 0;
                            //huy nhan tren phuc tham => update ve so tham
                            if (oVuan.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM)
                            {
                                oVuan.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            }

                            dt.SaveChanges();
                        }
                        else
                        {
                            lbthongbao.Text = "Án đã được thụ lý. Không được phép hủy nhận án.";
                            return;
                        }
                    }
                }
            }

            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            lbthongbao.Text = "Hủy nhận án thành công.";
        }
    }
}