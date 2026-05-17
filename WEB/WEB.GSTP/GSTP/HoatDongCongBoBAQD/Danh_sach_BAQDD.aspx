<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danh_sach_BAQDD.aspx.cs" Inherits="WEB.GSTP.GSTP.HoatDongCongBoBAQD.Danh_sach_BAQDD" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Chi tiết thông kê bản án/quyết định theo đơn vị</h4>
                <div class="boder" style="padding: 10px;">
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
                                 <asp:ListItem Value="7" Text="7" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20" ></asp:ListItem>
                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <asp:DataGrid ID="gridHS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        GridLines="None" PagerStyle-Mode="NumericPages"
                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%"
                        OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                        <Columns>
                            <asp:BoundColumn DataField="THAM_PHAN_ID" Visible="false"></asp:BoundColumn>
                            <asp:BoundColumn DataField="DONVI_TEN" HeaderText="Tên đơn vị" HeaderStyle-Width="80px"  HeaderStyle-HorizontalAlign= "Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="THAM_PHAN_TEN" HeaderText="Tên thẩm phán" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign= "Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="COLUMN_1" HeaderText="Bản án, quyết định đã công bố" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign= "Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="COLUMN_2" HeaderText="quyết định công bố chậm" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign= "Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="COLUMN_3" HeaderText="Bản án, quyết định có đính chính" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign= "Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="COLUMN_4" HeaderText="Bản án, quyết định đã gỡ xuống" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign= "Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="COLUMN_5" HeaderText="Bản án, quyết định có áp dụng án lệ" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign= "Center"></asp:BoundColumn>
                        </Columns>
                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                    </asp:DataGrid>
                    <div class="phantrang" style="margin-top:15px;">
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
                                <asp:ListItem Value="7" Text="7" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20" ></asp:ListItem>
                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
