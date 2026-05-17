<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="QuanlyMuonTra.aspx.cs" Inherits="WEB.GSTP.QLAN.QLHS.QuanlyMuonTra" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

       <asp:Panel ID="pnDanhsach" runat="server">
    <script src="../../../UI/js/Common.js"></script> 
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />

        <asp:HiddenField ID="hddVuViecID" runat="server" Value="0" />
        <asp:HiddenField ID="hddLoaiAn" runat="server" Value="0" />
        <asp:HiddenField ID="hddCapxx" runat="server" Value="0" />

        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <table class="table1">
                        <tr>
                            <td colspan="2">
                                <div class="boxchung">
                                    <h4 class="tleboxchung">Tìm kiếm</h4>
                                    <div class="boder" style="padding: 10px;">
                                        <table class="table1">
                                            <tr>
                                                <td>
                                                    <div style="float: left; width: 1050px">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Cấp Xét xử</div>
                                                        <div style="float: left;">
                                                          <asp:DropDownList ID="dropCapxx" CssClass="chosen-select" runat="server" Width="132px"
                                                        AutoPostBack="True" OnSelectedIndexChanged="dropCapxx_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">Loại án</div>
                                                        <div style="float: left;">
                                                             <asp:DropDownList ID="dropLoaian" CssClass="chosen-select" runat="server" Width="132px" AutoPostBack="true" OnSelectedIndexChanged="dropLoaian_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 77px; text-align: right; margin-right: 10px;">Số thụ lý</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="123px" MaxLength="50"></asp:TextBox>
                                                        </div>

                                                        <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">Ngày thụ lý</div>
                                                        <div style="float: left;">
                                                              <asp:TextBox ID="txtNgaythuly" runat="server" CssClass="user" Width="123px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaythuly" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaythuly" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgaythuly" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                    </div>


                                                     <div style="float: left; width: 1050px;margin-top: 8px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Số BA/QĐ</div>
                                                        <div style="float: left;">
                                                         <asp:TextBox ID="txtBAQD" CssClass="user" runat="server" Width="123px" MaxLength="50"></asp:TextBox>
                                                        </div>
                                                        <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">Ngày BA/QĐ</div>
                                                        <div style="float: left;">
                                                             <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="123px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayBAQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                        <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Từ ngày</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="123px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>

                                                        <div style="float: left; width: 70px; text-align: right; margin-right: 10px;">Đến ngày</div>
                                                        <div style="float: left;">
                                                        <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="123px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                    </div> 

                                                     <div style="float: left; width: 1050px;margin-top: 8px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thẩm phán chủ tọa</div>
                                                        <div style="float: left;">
                                                        <asp:TextBox ID="txtThamphan" CssClass="user" runat="server" Width="123px" MaxLength="250"></asp:TextBox>
                                                        </div>
                                                        <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">Thư ký</div>
                                                        <div style="float: left;">
                                                              <asp:TextBox ID="txtThuky" CssClass="user" runat="server" Width="123px" MaxLength="250"></asp:TextBox>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;"><asp:Label ID="lblNguyenDon" runat="server" Text="Nguyên đơn"></asp:Label></div>
                                                        <div style="float: left;">
                                                               <asp:TextBox ID="txtNguyendon" CssClass="user" runat="server" Width="123px" MaxLength="50"></asp:TextBox>
                                                        </div>

                                                        <div style="float: left; width: 85px; text-align: right; margin-right: 10px;"> <asp:Label ID="lblBiDon" runat="server" Text="Bị đơn"></asp:Label></div>
                                                        <div style="float: left;">
                                                         <asp:TextBox ID="txtBidon" CssClass="user" runat="server" Width="123px" MaxLength="50"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                       <div style="float: left; width: 1050px;margin-top: 8px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tên vụ việc</div>
                                                        <div style="float: left;">
                                                     <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="123px" MaxLength="250"></asp:TextBox>
                                                        </div>
                                                        <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">Trạng thái</div>
                                                        <div style="float: left;">
                                                              <asp:DropDownList ID="ddTrangthai" CssClass="chosen-select" runat="server" Width="132px">
                                                        <asp:ListItem Value="-1" Text="Tất cả" Selected="True"></asp:ListItem>
                                                        <%-- <asp:ListItem Value="0" Text="Chưa lưu"></asp:ListItem>--%>
                                                        <asp:ListItem Value="1" Text="Đã lưu"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Có phiếu mượn"></asp:ListItem>

                                                        <asp:ListItem Value="3" Text="Đã chuyển"></asp:ListItem>
                                                        <%--    <asp:ListItem Value="4" Text="Có kháng cáo"></asp:ListItem>--%>
                                                    </asp:DropDownList>
                                                        </div>
                                                        
                                                    </div>
                                                </td>
 

                                            </tr>
                                        
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center;">
                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" OnClientClick="return validateSearch();" />
                                <asp:Button ID="cmd_exels" runat="server" CssClass="buttoninput" Text="Xuất excel" OnClick="cmdExport_Click" OnClientClick="return validateSearch();" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                <div class="phantrang" id="ptT" runat="server">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" PageSize="10" AllowPaging="True" GridLines="None"
                                    PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>



                                        <asp:TemplateColumn HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Số, ngày thụ lý</HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("SOTHULY")%>
                                                <br />
                                                <%#Eval("NGAYTHULY")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:BoundColumn DataField="LOAIAN" HeaderText="Trạng thái" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="MAGIAIDOAN" HeaderText="magiaidoan" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>


                                        <asp:BoundColumn DataField="TENLOAIAN" HeaderText="Loại án" HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>

                                        <asp:TemplateColumn HeaderStyle-Width="35px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>BA/QĐ</HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("SOBANAN")%>
                                                <br />
                                                <%#Eval("NGAYBANAN")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                            <HeaderTemplate>Tên vụ việc</HeaderTemplate>
                                            <ItemTemplate>

                                                <asp:Panel ID="pn_HanhChinh" runat="server">
                                                    NKK: <%#Eval("TENNGUYENDON")%>
                                                    <br />
                                                    NBK: <%#Eval("TENBIDON")%>
                                                    <br />
                                                </asp:Panel>

                                                <asp:Panel ID="pn_DanSu" runat="server">
                                                    NĐ: <%#Eval("TENNGUYENDON")%>
                                                    <br />
                                                    BĐ: <%#Eval("TENBIDON")%>
                                                    <br />
                                                </asp:Panel>

                                                <asp:Panel ID="pn_Khac" runat="server">
                                                    <%#Eval("TENVUVIEC")%>
                                                </asp:Panel>



                                            </ItemTemplate>
                                        </asp:TemplateColumn>


                                        <asp:BoundColumn DataField="GIAIDOANVUVIEC" HeaderText="Giai đoạn" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>

                                        <asp:BoundColumn DataField="QUANHEPL" HeaderText="Quan hệ QL (Tội danh)" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="THAMPHAN" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderText="Thẩm phán" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="THUKY" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderText="Thư ký" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>

                                        <asp:BoundColumn DataField="TRANGTHAIHOSO" HeaderText="Trạng thái" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="SOBANAN" HeaderText="Trạng thái" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYBANAN" HeaderText="Trạng thái" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>


                                        <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                                            <HeaderTemplate>Trạng thái</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Panel ID="pn_TTGQ_VT" runat="server" Visible="true">

                                                    <%-- Đã chuyển ngày…, đơn vị nhận….--%>
                                                 <%--   <div style='width: 100%;'>

                                                        <i><%# Convert.ToInt32(Eval("TRANGTHAIHOSO"))==3 || Convert.ToInt32(Eval("TRANGTHAIHOSO_LICHSU"))==1 ? Eval("TENTRANGTHAIHOSO")
                                                                   +"<br/> Ngày: " + Eval("NGAYGIAONHANHOSO") 
                                                                   +"<br/> Đơn vị nhận: " + Eval("TENDONVINHANHOSO") 
                                                                   
                                                                   :Eval("TENTRANGTHAIHOSO") %></i>
                                                    </div>--%>

                                                     <div style='width: 100%;'>

                                                        <i><%# Convert.ToInt32(Eval("TRANGTHAIHOSO"))==3 && Convert.ToInt32(Eval("TRANGTHAIHOSO_LICHSU"))!=1 ? Eval("TENTRANGTHAIHOSO")
                                                                   +"<br/> Ngày: " + Eval("NGAYGIAONHANHOSO") 
                                                                   +"<br/> Đơn vị nhận: " + Eval("TENDONVINHANHOSO") 
                                                                   
                                                                   :"" %></i>
                                                         <i><%# Convert.ToInt32(Eval("TRANGTHAIHOSO_LICHSU"))==1 ? "Có phiếu mượn"
                                                                   +"<br/> Ngày: " + Eval("NGAYGIAONHANHOSO") 
                                                                   +"<br/> Đơn vị mượn: " + Eval("TENDONVINHANHOSO") 
                                                                   
                                                                   :""%></i>
                                                           <i><%# (  Convert.ToInt32(Eval("TRANGTHAIHOSO")) ==1 ) &&  Convert.ToInt32(Eval("TRANGTHAIHOSO_LICHSU"))!=1 ? Eval("TENTRANGTHAIHOSO")
                                                                   :"" %></i>
                                                    </div>
                                                </asp:Panel>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>

                                                <asp:LinkButton ID="lblSua" runat="server" CausesValidation="false" Text="Quản lý hồ sơ" ForeColor="#0e7eee"
                                                    CommandName="Sua" CommandArgument='<%#Eval("ID") %>' ToolTip="Cập nhật"></asp:LinkButton>
                                                <br></br>
                                                <%--  <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Hủy" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>--%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <%-- 
                                     
                                        <asp:BoundColumn DataField="Thamphan" HeaderText="Thẩm phán" HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="" HeaderText="Thư ký" HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TenToaAn" HeaderText="Tòa án" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                     
                                        <asp:BoundColumn DataField="KETQUA" HeaderText="Trạng thái" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>

                                                <asp:LinkButton ID="lblSua" runat="server" CausesValidation="false" Text="Sửa" ForeColor="#0e7eee"
                                                    CommandName="Sua" CommandArgument='<%#Eval("ID") %>' ToolTip="Sửa"></asp:LinkButton>
                                               </br>
                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Hủy" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>

                                            </ItemTemplate>
                                        </asp:TemplateColumn>--%>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang" id="ptB" runat="server">
                                    <div class="sobanghi">
                                        <asp:HiddenField ID="hdicha" runat="server" />
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </asp:Panel>
    <script type="text/javascript">

        function popup_capnhat(VuViecID, LoaiAn, Capxx, TRANGTHAI, SOBANAN, NGAYBANAN) {
            var link = "/QLAN/QLHS/Popup/pp_CapNhatMuonTra.aspx?VuViecID=" + VuViecID + "&LoaiAn=" + LoaiAn + "&Capxx=" + Capxx + "&TRANGTHAI=" + TRANGTHAI + '&SOBANAN=' + SOBANAN + '&NGAYBANAN=' + NGAYBANAN;
            var width = 800;
            var height = 500;
            PopupCenter(link, "Thêm tội danh", width, height);
        }
        function ReLoadGrid() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }
        function validateSearch() {
            var txtTuNgay = document.getElementById('<%=txtTuNgay.ClientID%>');
            var lengthTuNgay = txtTuNgay.value.trim().length;
            var TuNgay;
            if (lengthTuNgay > 0) {
                var arr = txtTuNgay.value.split('/');
                TuNgay = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (TuNgay.toString() == "NaN" || TuNgay.toString() == "Invalid Date") {
                    alert('Bạn phải nhập kháng cáo từ ngày theo định dạng (dd/MM/yyyy).');
                    txtTuNgay.focus();
                    return false;
                }
            }
            var txtDenNgay = document.getElementById('<%=txtDenNgay.ClientID%>');
            var lengthDenNgay = txtDenNgay.value.trim().length;
            var DenNgay;
            if (lengthDenNgay > 0) {
                var arr = txtDenNgay.value.split('/');
                DenNgay = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (DenNgay.toString() == "NaN" || DenNgay.toString() == "Invalid Date") {
                    alert('Bạn phải nhập kháng cáo đến ngày theo định dạng (dd/MM/yyyy).');
                    txtDenNgay.focus();
                    return false;
                }
            }
            if (lengthTuNgay > 0 && lengthDenNgay > 0 && TuNgay > DenNgay) {
                alert('Ngày kháng cáo từ ngày phải nhỏ hơn đến ngày.');
                txtDenNgay.focus();
                return false;
            }
            return true;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
