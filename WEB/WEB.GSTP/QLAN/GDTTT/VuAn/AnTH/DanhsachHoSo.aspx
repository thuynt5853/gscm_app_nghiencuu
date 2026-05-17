<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
    AutoEventWireup="true" CodeBehind="DanhsachHoSo.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.AnTH.DanhsachHoSo" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style type="text/css">
        .DonGDTCol1 {
            width: 100px;
        }

        .DonGDTCol2 {
            width: 240px;
        }

        .DonGDTCol3 {
            width: 80px;
        }

        .DonGDTCol4 {
            width: 160px;
        }

        .DonGDTCol5 {
            width: 70px;
        }

        .full_width {
            float: left;
            width: 100%;
        }

        .link_view {
            color: #0e7eee;
            font-weight: bold;
            text-decoration: none;
        }
    </style>
    <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm
                                    <asp:LinkButton ID="lbtTTTK" runat="server" Text="[ Nâng cao ]" ForeColor="#0E7EEE" OnClick="lbtTTTK_Click"></asp:LinkButton></h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td class="DonGDTCol1">Tòa ra BA/QĐ</td>
                                            <td class="DonGDTCol2">
                                                <asp:DropDownList ID="ddlToaXetXu" CssClass="chosen-select"
                                                    runat="server" Width="230px">
                                                </asp:DropDownList>
                                            </td>
                                            <td class="DonGDTCol3">Số BA/QĐ</td>
                                            <td class="DonGDTCol4">
                                                <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>
                                            </td>
                                            <td class="DonGDTCol5">Ngày BA/QĐ</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblTitleBA" runat="server" Text="Bị án"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txtBian" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                            
                                            <td>Loại án</td>
                                            <td >  
                                                <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged"
                                                    runat="server" Width="160px">
                                                </asp:DropDownList>
                                            </td>
                                            <td>Hồ sơ giảm án</td>
                                            <td >  
                                                 <asp:DropDownList ID="ddlIsHoSoAnGiam"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlIsHoSoAnGiam_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                         <asp:ListItem Value="0" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã tạo hồ sơ ân giảm" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Chưa tạo hồ sơ ân giảm"></asp:ListItem>
                                                    </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <asp:Panel ID="pnTTTK" runat="server" Visible="false">
                                            <tr>
                                                <td>Ngày tạo từ ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtTao_Tu" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtTao_Tu" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtTao_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtTao_Den" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtTao_Den" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtTao_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Số thụ lý</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_So" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Thẩm tra viên
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamtravien" CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>LĐ phụ trách</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlPhoVuTruong" CssClass="chosen-select"
                                                        runat="server" Width="160px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlPhoVuTruong_SelectedIndexChanged">
                                                    </asp:DropDownList></td>
                                                <td>Thẩm phán</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamphan"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlThamphan_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                    </asp:DropDownList></td>
                                            </tr>
                                           
                                            
                                            <tr>
                                                <td>Trạng thái hồ sơ</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlMuonHoso" runat="server"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlMuonHoso_SelectedIndexChanged"
                                                        Width="160px" CssClass="chosen-select">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã có hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa có hồ sơ"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Tờ trình lãnh đạo</td>
                                                <td colspan =" 3">
                                                    <asp:DropDownList ID="ddlTotrinh"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlTotrinh_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã có tờ trình"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa có tờ trình"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                               
                                            </tr>
                                            <tr>
                                                <td>Trạng thái thụ lý</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTrangthaithuly"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlTrangthaithuly_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:Literal ID="lttYKienKetLuan" runat="server">Ý kiến tờ trình</asp:Literal></td>
                                                <td colspan=" 3">
                                                    <asp:DropDownList ID="dropIsYKienKetLuatTrinhLD"
                                                        CssClass="chosen-select" runat="server" Width="160px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropIsYKienKetLuatTrinhLD_SelectedIndexChanged">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa có ý kiến"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã có ý kiến"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="... Kháng nghị"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="... Không Kháng nghị"></asp:ListItem>
                                                        
                                                    </asp:DropDownList></td>
                                                
                                            </tr>                         
                                        </asp:Panel>

                                        <tr>
                                            <td></td>
                                            <td align="left" colspan="3">
                                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                            </td>
                                            <td align="right" colspan="2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td colspan="5"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="6">
                                                <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">In báo cáo
                                    <asp:LinkButton ID="lkInBC_OpenForm" runat="server" Text="[ Mở ]"
                                        ForeColor="#0E7EEE" OnClick="lkInBC_OpenForm_Click"></asp:LinkButton></h4>
                                <div class="boder" style="padding: 10px;">
                                    <asp:Panel ID="pnInBC" runat="server" Visible="false">
                                        <table class="table1">
                                            <tr>
                                                <td class="DonGDTCol1">Tiêu đề báo cáo</td>
                                                <td>
                                                    <asp:TextBox ID="txtTieuDeBC" runat="server"
                                                        CssClass="user" Width="486px" MaxLength="250" Text="Danh sách các vụ án"></asp:TextBox>
                                                    <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput"
                                                        Text="In biểu mẫu" OnClick="cmdPrint_Click" /></td>
                                            </tr>
                                            <tr style="display: none;">
                                                <td>Mẫu báo cáo</td>
                                                <td>
                                                    <asp:DropDownList ID="dropMauBC" CssClass="chosen-select" runat="server" Width="494px">
                                                        <asp:ListItem Value="1" Text="Mẫu 1: Thống kê vụ án chưa có hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Mẫu 2: Thống kê vụ án đã có hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Mẫu 3: Thống kê vụ án chưa/có tờ trình lãnh đạo vụ"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Mẫu 4: Thống kê vụ án đang trong giai đoạn giải quyết tờ trình"></asp:ListItem>
                                                        <asp:ListItem Value="5" Text="Mẫu 5: Danh sách án Quốc Hội"></asp:ListItem>
                                                    </asp:DropDownList>

                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" Visible="false"
                                        AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
 
                            <asp:DataGrid ID="dgListHS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>

                                    <asp:BoundColumn DataField="STT" HeaderText="TT"
                                        HeaderStyle-Width="10px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                     <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin bị án</HeaderTemplate>
                                        <ItemTemplate>
                                            <b>Họ tên: </b><%#Eval("TENDUONGSU")%>
                                            <br />
                                            <b>Sinh năm: </b><%#Eval("NAMSINH")%>
                                            <br />
                                            <b>Địa chỉ: </b><%#Eval("DIACHI")%>
                                            <br />
                                            <b>Tội danh: </b><%#Eval("HS_TENTOIDANH")%> 
                                            <br />
                                            <b>Mức án: </b><%#Eval("HS_MUCAN")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                           <%-- Số & Ngày thụ lý--%>
                                            Người gửi đơn/Số đơn
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#(Eval("listDonVu")+"")%>
                                            <br /><%#(Eval("LisThuLyDon")+"").Replace(";", ",<br/>")%>               
                                            <br style="margin-top: 5px;" />
                                            <asp:LinkButton ID="cmdSoDonTrung" runat="server" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("vuanid") +"#"+ Eval("ds_id") %>' CommandName="SoDon"
                                                Text='<%# "Số đơn " + Eval("TongDon") %>'></asp:LinkButton>
                                            
                                            
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM", "{0:dd/MM/yyyy}")%>
                                            <br />
                                            <%#Eval("TOAXETXU")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                   

                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thẩm tra viên<br />
                                            Lãnh đạo Vụ<br />
                                            Thẩm phán
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%# String.IsNullOrEmpty(Eval("TENTHAMTRAVIEN")+"")? "":("TTV:<b style='margin-left:3px;'>"+Eval("TENTHAMTRAVIEN")+"</b><br />")%>
                                            <%# String.IsNullOrEmpty(Eval("TENLANHDAO")+"")? "":( "LĐV:<b style='margin-left:3px;'>"+Eval("TENLANHDAO")+"</b><br />")%>
                                            <%# String.IsNullOrEmpty(Eval("TENTHAMPHAN")+"")? "":("TP:<b style='margin-left:3px;'>"+Eval("TENTHAMPHAN")+"</b>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    

                                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Tình Trạng
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%# String.IsNullOrEmpty(Eval("TinhTrang")+"")? "":("<b style='margin-left:3px;'>"+Eval("TinhTrang")+"</b>")%>
                                            
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    
                                    <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                           
                                          <%--  <a href="javascript:;" class="link_view" onclick='ViewVuAn(<%#Eval("ID") %>, <%#Eval("VUAN_ID") %>)'>Xem Thông tin</a>
                                            <br /> 
                                            --%>
                                            <%--<a href="javascript:;" class="link_view"  onclick='Totrinh_TH(<%#Eval("ID") %>, <%#Eval("VUAN_ID") %>)'>Sửa </a>
                                            <a href="javascript:;" class="link_view" onclick='Totrinh_TH(<%#Eval("ID") %>, <%#Eval("VUAN_ID") %>)'>Xóa </a>--%>
                                             <asp:LinkButton ID="lbltaoHS" runat="server" Text="Tạo Hồ sơ xin ân giảm" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                                    CommandName="TAO_HS"  CommandArgument='<%#Eval("vuanid") +"#"+ Eval("ds_id") %>' Visible='<%#String.IsNullOrEmpty(Eval("ID")+"")?true:false%>' ></asp:LinkButton>
                                         
                                            <asp:LinkButton ID="lblXoaHS" runat="server" Text="Xóa Hồ sơ" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                                     CommandName="XoaHS" CommandArgument='<%#Eval("ID")%>' Visible='<%#String.IsNullOrEmpty(Eval("ID")+"")?false:true%>' ></asp:LinkButton>
                                            <br /> 
                                            <%#Eval("username") %>
                                            <br />
                                            <i><%#Eval("NGAYTAO") %></i>
                                            
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function PopupReport(pageURL, title, w, h) {
            //alert(pageURL);
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function ViewVuAn(id, vuan_id) {
            //  alert(vuan_id);
            var pageURL = '';
          
            pageURL = '/QLAN/GDTTT/VuAn/AnTH/ThongTinGQTH.aspx?hsid=' + id + '&vid=' + vuan_id;
            var title = 'Thông tin vụ án';
            var w = 1000;
            var h = 600;
            PopupReport(pageURL, title, w, h);
        }
        function Totrinh_TH(id,vuan_id) {
            
            var pageURL = '/QLAN/GDTTT/VuAn/AnTH/TOTRINH_GQHS.aspx?hsid=' + id + '&vid=' + vuan_id;
            
            var title = 'Tờ trình giải quyết xin ân giảm';
            var w = 1000;
            var h = 600;
            PopupReport(pageURL, title, w, h);
        }

        function LoadDsDon() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>

</asp:Content>
