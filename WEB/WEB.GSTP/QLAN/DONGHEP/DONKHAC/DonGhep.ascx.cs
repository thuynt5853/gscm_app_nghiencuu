using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
using Module.Common;
using BL.GSTP.DONGHEP;
using System.Data;
using System.Globalization;


namespace WEB.GSTP.QLAN.DONGHEP.DONKHAC
{
    public partial class DonGhep : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal DONID;
        public Decimal LOAIANID;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGrid();
            }
        }
        public void hiddenbtnThemMoi()
        {
            lbtThemdonmoi.Visible = false;
        }
        private void LoadGrid()
        {
            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string keyDonID = "DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            string keyLoaiAnId = "DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            DONID = Convert.ToDecimal(Session[keyDonID]);
            LOAIANID = Convert.ToDecimal(Session[keyLoaiAnId]);
            int page_size = 10,
                pageindex = Convert.ToInt32(hddPageIndex.Value);
            DONGHEP_BL oBL = new DONGHEP_BL();
            DataTable oDT = oBL.GetDonGhepDonKC(vDonViID, DONID, LOAIANID);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                var count_all = Convert.ToInt32(oDT.Rows.Count);
                if (dgList.CurrentPageIndex > (Convert.ToInt32(hddTotalPage.Value) - 1))
                {
                    dgList.CurrentPageIndex = 0;
                }
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
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

            dgList.DataSource = oDT;
            dgList.DataBind();
            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                //LtrThongBao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                lbtThemdonmoi.Visible = false;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");

                LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");

                if (!string.IsNullOrEmpty(e.Item.Cells[2].Text) && e.Item.Cells[2].Text != "&nbsp;")
                {
                    //thêm bằng tay
                    lbtXoa.Text = "Hủy ghép";
                    lbtXoa.OnClientClick = "return confirm('Bạn thực sự muốn hủy ghép bản ghi này? ');";
                }
                else
                {
                    //thêm từ dkk
                    lbtXoa.Text = "Xóa";
                    lbtXoa.OnClientClick = "return confirm('Bạn thực sự muốn xóa bản ghi này? ');";
                }
                LinkButton lbtXuLyDon = (LinkButton)e.Item.FindControl("lbtXuLyDon");
                if (rowView["LOAIDON"].ToString() == "Đơn kháng cáo" || rowView["LOAIDON"].ToString() == "Đơn kháng nghị")
                {
                    lbtXuLyDon.Visible = false;
                }
                else
                {
                    lbtXuLyDon.Visible = true;
                }
                string toagiaiquyetID = e.Item.Cells[12].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lbtSua.Visible = false;
                    lbtXuLyDon.Visible = false;
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string[] arg = new string[2];
            arg = e.CommandArgument.ToString().Split(';');
            decimal ND_id = Convert.ToDecimal(arg[0]);
            decimal LoaiDon = Convert.ToDecimal(arg[1]);
            //string keyDonID = "DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            string keyLoaiAnId = "DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            LOAIANID = Convert.ToDecimal(Session[keyLoaiAnId]);
            switch (e.CommandName)
            {
                case "XuLyDon":
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_XuLyDon(" + LOAIANID + "," + ND_id + " ," + LoaiDon + ")");
                    break;
                case "Sua":
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_edit_DONGHEP(" + LOAIANID + "," + ND_id + " ," + LoaiDon + ")");
                    break;
                case "Xoa":
                    int count = 0;
                    int DuongSu = 0;
                    if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU))
                    {
                        DON_KHAC obj = dt.DON_KHAC.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                        if (obj.TTGQ == null)
                        {
                            dt.DON_KHAC.Remove(obj);
                            dt.SaveChanges();
                            LtrThongBao.Text = "Xóa thành công";
                            lbtimkiem_Click(null, null);
                        }
                        else
                        {
                            LtrThongBao.Text = "Đơn đã được thụ lý, không thể xóa";
                        }
                    }
                    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_DANSU))
                    {
                        if (LoaiDon != 7 && LoaiDon != 8)
                        {
                            DON_CHITIET obj = dt.DON_CHITIET.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                            count = dt.ADS_DON_XULY.Count(s => s.DON_CHITIETID == obj.ID);
                            if (count > 0)
                            {
                                LtrThongBao.Text = "Đơn đã được giải quyết, không thể xóa";
                            }
                            else
                            {
                                List<DON_DUONGSU_CHITIET> lstDonChiTietDuongSu = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == obj.ID).ToList();
                                foreach (DON_DUONGSU_CHITIET item in lstDonChiTietDuongSu)
                                {
                                    ADS_ANPHI DsAnPhi = dt.ADS_ANPHI.Where(x => x.DUONGSU_ID == item.DUONGSUID && x.DONID == item.DONID).FirstOrDefault();
                                    if (DsAnPhi != null)
                                    {
                                        DuongSu++;
                                    }
                                }
                                if (DuongSu >= 1)
                                {
                                    LtrThongBao.Text = "Đơn đã được nộp án phí, không thể xóa";
                                }
                                else
                                {
                                    dt.DON_CHITIET.Remove(obj);
                                    dt.SaveChanges();
                                    LtrThongBao.Text = "Xóa thành công";
                                    lbtimkiem_Click(null, null);
                                }

                            }
                        }
                        else
                        {
                            DON_KHAC obj = dt.DON_KHAC.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                            count = dt.AHN_DON_XULY.Count(s => s.DON_CHITIETID == obj.ID);
                            if (count > 0)
                            {
                                LtrThongBao.Text = "Đơn đã được giải quyết, không thể xóa";
                            }
                            else
                            {
                                if (obj.ISDUONGSU == 0)
                                {
                                    dt.DON_KHAC.Remove(obj);
                                    dt.SaveChanges();
                                    LtrThongBao.Text = "Xóa thành công";
                                    lbtimkiem_Click(null, null);
                                }
                                else
                                {
                                    ADS_ANPHI DsAnPhi = dt.ADS_ANPHI.Where(x => x.DUONGSU_ID == obj.DUONGSUID && x.DONID == obj.DONID).FirstOrDefault();
                                    if (DsAnPhi == null)
                                    {
                                        dt.DON_KHAC.Remove(obj);
                                        dt.SaveChanges();
                                        LtrThongBao.Text = "Xóa thành công";
                                        lbtimkiem_Click(null, null);
                                    }
                                    else
                                    {
                                        LtrThongBao.Text = "Đơn đã được nộp án phí, không thể xóa";
                                    }
                                }
                            }
                        }

                    }
                    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH))
                    {
                        if (LoaiDon != 10 && LoaiDon != 11)
                        {
                            DON_CHITIET obj = dt.DON_CHITIET.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                            count = dt.AHN_DON_XULY.Count(s => s.DON_CHITIETID == obj.ID);
                            if (count > 0)
                            {
                                LtrThongBao.Text = "Đơn đã được giải quyết, không thể xóa";
                            }
                            else
                            {
                                List<DON_DUONGSU_CHITIET> lstDonChiTietDuongSu = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == obj.ID).ToList();
                                foreach (DON_DUONGSU_CHITIET item in lstDonChiTietDuongSu)
                                {
                                    AHN_ANPHI DsAnPhi = dt.AHN_ANPHI.Where(x => x.DUONGSU_ID == item.DUONGSUID && x.DONID == item.DONID).FirstOrDefault();
                                    if (DsAnPhi != null)
                                    {
                                        DuongSu++;
                                    }
                                }
                                if (DuongSu >= 1)
                                {
                                    LtrThongBao.Text = "Đơn đã được nộp án phí, không thể xóa";
                                }
                                else
                                {
                                    dt.DON_CHITIET.Remove(obj);
                                    dt.SaveChanges();
                                    LtrThongBao.Text = "Xóa thành công";
                                    lbtimkiem_Click(null, null);
                                }

                            }
                        }
                        else
                        {
                            DON_KHAC obj = dt.DON_KHAC.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                            count = dt.AHN_DON_XULY.Count(s => s.DON_CHITIETID == obj.ID);
                            if (count > 0)
                            {
                                LtrThongBao.Text = "Đơn đã được giải quyết, không thể xóa";
                            }
                            else
                            {
                                if (obj.ISDUONGSU == 0)
                                {
                                    dt.DON_KHAC.Remove(obj);
                                    dt.SaveChanges();
                                    LtrThongBao.Text = "Xóa thành công";
                                    lbtimkiem_Click(null, null);
                                }
                                else
                                {
                                    AHN_ANPHI DsAnPhi = dt.AHN_ANPHI.Where(x => x.DUONGSU_ID == obj.DUONGSUID && x.DONID == obj.DONID).FirstOrDefault();
                                    if (DsAnPhi == null)
                                    {
                                        dt.DON_KHAC.Remove(obj);
                                        dt.SaveChanges();
                                        LtrThongBao.Text = "Xóa thành công";
                                        lbtimkiem_Click(null, null);
                                    }
                                    else
                                    {
                                        LtrThongBao.Text = "Đơn đã được nộp án phí, không thể xóa";
                                    }
                                }
                            }
                        }
                    }
                    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI))
                    {
                        if (LoaiDon != 7 && LoaiDon != 8)
                        {
                            DON_CHITIET obj = dt.DON_CHITIET.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                            count = dt.AKT_DON_XULY.Count(s => s.DON_CHITIETID == obj.ID);
                            if (count > 0)
                            {
                                LtrThongBao.Text = "Đơn đã được giải quyết, không thể xóa";
                            }
                            else
                            {
                                List<DON_DUONGSU_CHITIET> lstDonChiTietDuongSu = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == obj.ID).ToList();
                                foreach (DON_DUONGSU_CHITIET item in lstDonChiTietDuongSu)
                                {
                                    AKT_ANPHI DsAnPhi = dt.AKT_ANPHI.Where(x => x.DUONGSU_ID == item.DUONGSUID && x.DONID == item.DONID).FirstOrDefault();
                                    if (DsAnPhi != null)
                                    {
                                        DuongSu++;
                                    }
                                }
                                if (DuongSu >= 1)
                                {
                                    LtrThongBao.Text = "Đơn đã được nộp án phí, không thể xóa";
                                }
                                else
                                {
                                    dt.DON_CHITIET.Remove(obj);
                                    dt.SaveChanges();
                                    LtrThongBao.Text = "Xóa thành công";
                                    lbtimkiem_Click(null, null);
                                }

                            }
                        }
                        else
                        {
                            DON_KHAC obj = dt.DON_KHAC.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                            count = dt.AHN_DON_XULY.Count(s => s.DON_CHITIETID == obj.ID);
                            if (count > 0)
                            {
                                LtrThongBao.Text = "Đơn đã được giải quyết, không thể xóa";
                            }
                            else
                            {
                                if (obj.ISDUONGSU == 0)
                                {
                                    dt.DON_KHAC.Remove(obj);
                                    dt.SaveChanges();
                                    LtrThongBao.Text = "Xóa thành công";
                                    lbtimkiem_Click(null, null);
                                }
                                else
                                {
                                    AKT_ANPHI DsAnPhi = dt.AKT_ANPHI.Where(x => x.DUONGSU_ID == obj.DUONGSUID && x.DONID == obj.DONID).FirstOrDefault();
                                    if (DsAnPhi == null)
                                    {
                                        dt.DON_KHAC.Remove(obj);
                                        dt.SaveChanges();
                                        LtrThongBao.Text = "Xóa thành công";
                                        lbtimkiem_Click(null, null);
                                    }
                                    else
                                    {
                                        LtrThongBao.Text = "Đơn đã được nộp án phí, không thể xóa";
                                    }
                                }
                            }
                        }
                    }
                    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG))
                    {
                        if (LoaiDon != 7 && LoaiDon != 8)
                        {
                            DON_CHITIET obj = dt.DON_CHITIET.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                            count = dt.ALD_DON_XULY.Count(s => s.DON_CHITIETID == obj.ID);
                            if (count > 0)
                            {
                                LtrThongBao.Text = "Đơn đã được giải quyết, không thể xóa";
                            }
                            else
                            {
                                List<DON_DUONGSU_CHITIET> lstDonChiTietDuongSu = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == obj.ID).ToList();
                                foreach (DON_DUONGSU_CHITIET item in lstDonChiTietDuongSu)
                                {
                                    ALD_ANPHI DsAnPhi = dt.ALD_ANPHI.Where(x => x.DUONGSU_ID == item.DUONGSUID && x.DONID == item.DONID).FirstOrDefault();
                                    if (DsAnPhi != null)
                                    {
                                        DuongSu++;
                                    }
                                }
                                if (DuongSu >= 1)
                                {
                                    LtrThongBao.Text = "Đơn đã được nộp án phí, không thể xóa";
                                }
                                else
                                {
                                    dt.DON_CHITIET.Remove(obj);
                                    dt.SaveChanges();
                                    LtrThongBao.Text = "Xóa thành công";
                                    lbtimkiem_Click(null, null);
                                }

                            }
                        }
                        else
                        {
                            DON_KHAC obj = dt.DON_KHAC.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                            count = dt.AHN_DON_XULY.Count(s => s.DON_CHITIETID == obj.ID);
                            if (count > 0)
                            {
                                LtrThongBao.Text = "Đơn đã được giải quyết, không thể xóa";
                            }
                            else
                            {
                                if (obj.ISDUONGSU == 0)
                                {
                                    dt.DON_KHAC.Remove(obj);
                                    dt.SaveChanges();
                                    LtrThongBao.Text = "Xóa thành công";
                                    lbtimkiem_Click(null, null);
                                }
                                else
                                {
                                    ALD_ANPHI DsAnPhi = dt.ALD_ANPHI.Where(x => x.DUONGSU_ID == obj.DUONGSUID && x.DONID == obj.DONID).FirstOrDefault();
                                    if (DsAnPhi == null)
                                    {
                                        dt.DON_KHAC.Remove(obj);
                                        dt.SaveChanges();
                                        LtrThongBao.Text = "Xóa thành công";
                                        lbtimkiem_Click(null, null);
                                    }
                                    else
                                    {
                                        LtrThongBao.Text = "Đơn đã được nộp án phí, không thể xóa";
                                    }
                                }
                            }
                        }
                    }
                    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH))
                    {
                        if (LoaiDon != 7 && LoaiDon != 8)
                        {
                            DON_CHITIET obj = dt.DON_CHITIET.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                            count = dt.AHC_DON_XULY.Count(s => s.DON_CHITIETID == obj.ID);
                            if (count > 0)
                            {
                                LtrThongBao.Text = "Đơn đã được giải quyết, không thể xóa";
                            }
                            else
                            {
                                List<DON_DUONGSU_CHITIET> lstDonChiTietDuongSu = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == obj.ID).ToList();
                                foreach (DON_DUONGSU_CHITIET item in lstDonChiTietDuongSu)
                                {
                                    AHC_ANPHI DsAnPhi = dt.AHC_ANPHI.Where(x => x.DUONGSU_ID == item.DUONGSUID && x.DONID == item.DONID).FirstOrDefault();
                                    if (DsAnPhi != null)
                                    {
                                        DuongSu++;
                                    }
                                }
                                if (DuongSu >= 1)
                                {
                                    LtrThongBao.Text = "Đơn đã được nộp án phí, không thể xóa";
                                }
                                else
                                {
                                    dt.DON_CHITIET.Remove(obj);
                                    dt.SaveChanges();
                                    LtrThongBao.Text = "Xóa thành công";
                                    lbtimkiem_Click(null, null);
                                }

                            }
                        }
                        else
                        {
                            DON_KHAC obj = dt.DON_KHAC.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                            count = dt.AHN_DON_XULY.Count(s => s.DON_CHITIETID == obj.ID);
                            if (count > 0)
                            {
                                LtrThongBao.Text = "Đơn đã được giải quyết, không thể xóa";
                            }
                            else
                            {
                                if (obj.ISDUONGSU == 0)
                                {
                                    dt.DON_KHAC.Remove(obj);
                                    dt.SaveChanges();
                                    LtrThongBao.Text = "Xóa thành công";
                                    lbtimkiem_Click(null, null);
                                }
                                else
                                {
                                    AHC_ANPHI DsAnPhi = dt.AHC_ANPHI.Where(x => x.DUONGSU_ID == obj.DUONGSUID && x.DONID == obj.DONID).FirstOrDefault();
                                    if (DsAnPhi == null)
                                    {
                                        dt.DON_KHAC.Remove(obj);
                                        dt.SaveChanges();
                                        LtrThongBao.Text = "Xóa thành công";
                                        lbtimkiem_Click(null, null);
                                    }
                                    else
                                    {
                                        LtrThongBao.Text = "Đơn đã được nộp án phí, không thể xóa";
                                    }
                                }
                            }
                        }
                    }
                    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN))
                    {
                        if (LoaiDon != 7 && LoaiDon != 8)
                        {
                            DON_CHITIET obj = dt.DON_CHITIET.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                            count = dt.APS_DON_XULY.Count(s => s.DON_CHITIETID == obj.ID);
                            if (count > 0)
                            {
                                LtrThongBao.Text = "Đơn đã được giải quyết, không thể xóa";
                            }
                            else
                            {
                                List<DON_DUONGSU_CHITIET> lstDonChiTietDuongSu = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == obj.ID).ToList();
                                foreach (DON_DUONGSU_CHITIET item in lstDonChiTietDuongSu)
                                {
                                    APS_ANPHI DsAnPhi = dt.APS_ANPHI.Where(x => x.DUONGSU_ID == item.DUONGSUID && x.DONID == item.DONID).FirstOrDefault();
                                    if (DsAnPhi != null)
                                    {
                                        DuongSu++;
                                    }
                                }
                                if (DuongSu >= 1)
                                {
                                    LtrThongBao.Text = "Đơn đã được nộp án phí, không thể xóa";
                                }
                                else
                                {
                                    dt.DON_CHITIET.Remove(obj);
                                    dt.SaveChanges();
                                    LtrThongBao.Text = "Xóa thành công";
                                    lbtimkiem_Click(null, null);
                                }

                            }
                        }
                        else
                        {
                            DON_KHAC obj = dt.DON_KHAC.FirstOrDefault(s => s.ID == ND_id && s.LOAIANID == LOAIANID);
                            count = dt.AHN_DON_XULY.Count(s => s.DON_CHITIETID == obj.ID);
                            if (count > 0)
                            {
                                LtrThongBao.Text = "Đơn đã được giải quyết, không thể xóa";
                            }
                            else
                            {
                                if (obj.ISDUONGSU == 0)
                                {
                                    dt.DON_KHAC.Remove(obj);
                                    dt.SaveChanges();
                                    LtrThongBao.Text = "Xóa thành công";
                                    lbtimkiem_Click(null, null);
                                }
                                else
                                {
                                    APS_ANPHI DsAnPhi = dt.APS_ANPHI.Where(x => x.DUONGSU_ID == obj.DUONGSUID && x.DONID == obj.DONID).FirstOrDefault();
                                    if (DsAnPhi == null)
                                    {
                                        dt.DON_KHAC.Remove(obj);
                                        dt.SaveChanges();
                                        LtrThongBao.Text = "Xóa thành công";
                                        lbtimkiem_Click(null, null);
                                    }
                                    else
                                    {
                                        LtrThongBao.Text = "Đơn đã được nộp án phí, không thể xóa";
                                    }
                                }
                            }
                        }
                    }
                    break;
            }

        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbThemMoiDon_Click(object sender, EventArgs e)
        {
            //string keyDonID = "DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            string keyLoaiAnId = "DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            LOAIANID = Convert.ToDecimal(Session[keyLoaiAnId]);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_edit_DONGHEP(" + LOAIANID + ")");
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
    }
}